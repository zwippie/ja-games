import React, { Component } from "react"
import ServerPresets from "./presets.js"

function drawInlineSVG(svgElement, ctx, callback) {
  var svgURL = new XMLSerializer().serializeToString(svgElement)
  var img  = new Image()
  img.onload = function() {
    ctx.drawImage(this, 0,0)
    callback()
  }
  img.src = 'data:image/svg+xml; charset=utf8, ' + encodeURIComponent(svgURL)
}

function drawImageSVG(svgElement, ctx, callback) {
  var img  = new Image()
  img.onload = function() {
    ctx.drawImage(this, 0,0)
    callback()
  }
  img.src = svgElement.src
}

class Spijkerplank extends Component {
  constructor(props) {
    super(props)

    this.presets = ServerPresets
    this.state = {
      rows: props.rows,
      cols: props.cols,
      dist: 50,
      offset: 20,
      size: 5,
      segments: props.segments,
      hoverIdx: false,
      selectedIdx: false,
      mousePos: [0, 0],
      preview: "//:0",  // svg data url
      example: this.presets[0].name, // name of preset
      showJSON: false
    }
    this.grid = this.createGrid()
  }

  componentDidMount() {
    this.save(false)
  }

  render() {
    const {rows, cols, dist, offset, segments, selectedIdx, preview, example, showJSON} = this.state
    const width = rows * dist // + offset
    const height = cols * dist // + offset

    const newSegment = selectedIdx === false ? null : this.renderNewSegment()

    return (
      <div id="spijkerplank">
        <div className="columns">
          <div className="column">
            <h2>Voorbeeld:</h2>
            <div className="area">
              <img src={preview} ref={img => this.imgPreview = img} alt="Voorbeeld" />
            </div>

            <div className="area has-addons">
              <div className="control">
                <div className="select">
                  <select value={example} onChange={this.handleExampleChange.bind(this)}>
                    {this.renderPresetOptions()}
                  </select>
                </div>
              </div>
              <div className="control">
                <button className="button" onClick={this.load.bind(this)}>Laden</button>
              </div>
            </div>

          </div>

          <div className="column">
            <h2>Teken hier iets moois, of teken een voorbeeld na:</h2>
            <div className="area">
              <svg ref={svg => this.svgGrid = svg} width={width} height={height} onMouseMove={this.handleMouseMove.bind(this)}>
                { newSegment }
                { segments.map((segment, i) => this.renderSegment(segment, i, "purple")) }
                { this.createGrid().map((point, i) => this.renderPoint(point, i)) }
              </svg>
            </div>

            <div className="buttons">
              <button className="button" onClick={this.undo.bind(this)}>Ongedaan maken</button>
              <button className="button" onClick={this.clear.bind(this)}>Wissen</button>
              <button className="button" onClick={this.save.bind(this)}>Opslaan</button>
              <button className="button" onClick={this.toggleCode.bind(this)}>Code</button>
              <button className="button" onClick={this.compare.bind(this)}>Vergelijken</button>
            </div>

            <div className={showJSON ? "notification is-primary" : "is-invisible"}>
              {JSON.stringify(segments)}
            </div>
          </div>

        </div>

        <div className="compare-canvas is-invisible">
          <canvas width={width} height={height} ref={canvas => this.canvasPreview = canvas} id="canvasPreview" />
          <canvas width={width} height={height} ref={canvas => this.canvasGrid = canvas} id="canvasGrid" />
        </div>
      </div>
    );
  }

  createGrid() {
    const {rows, cols, dist, offset} = this.state
    let grid = []
    for (var row = rows - 1; row >= 0; row--) {
      for (var col = cols - 1; col >= 0; col--) {
        grid = grid.concat([[row * dist + offset, col * dist + offset]])
      }
    }
    return grid.reverse()
  }

  cursorPoint(ev) {
    let pt = this.svgGrid.createSVGPoint()
    pt.x = ev.clientX
    pt.y = ev.clientY
    return pt.matrixTransform(this.svgGrid.getScreenCTM().inverse())
  }

  undo(ev) {
    const {segments, selectedIdx} = this.state
    const newSelectedIdx = selectedIdx === false ? selectedIdx :
      segments[segments.length -1] ? segments[segments.length -1][0] : false
    this.setState({
      segments: segments.slice(0, segments.length - 1),
      selectedIdx: newSelectedIdx
    })
  }

  clear(ev) {
    this.setState({segments: [], selectedIdx: false})
  }

  save(ev) {
    if (this.state.selectedIdx === false) {
      // perhaps we're also loading, and double setState callbacks don't work?!
      this.saveToExample()
    } else {
      // otherwise we make sure to remove the new/current segment from the saved image
      this.setState({selectedIdx: false}, () => {
        this.saveToExample()
      })
    }
  }

  saveToExample() {
    const serialized = new XMLSerializer().serializeToString(this.svgGrid)
    const imgSrc = "data:image/svg+xml;base64," + btoa(serialized)
    this.setState({preview: imgSrc})
  }

  load(ev) {
    const oldSegments = this.state.segments
    const segments = this.presets.find(preset => preset.name === this.state.example)
    this.setState({segments: segments.segments, selectedIdx: false}, () => {
      this.save()
      this.clear()
      this.setState({segments: oldSegments})
    })
  }

  compare(ev) {
    // Compare by rendering to canvas elements and comparing the image data
    // It doesn't work when lines are double drawn.
    const {rows, cols, dist, offset} = this.state
    const width = rows * dist + offset
    const height = cols * dist + offset

    let previewContext = this.canvasPreview.getContext("2d")
    let gridContext = this.canvasGrid.getContext("2d")

    previewContext.clearRect(0, 0, this.canvasPreview.width, this.canvasPreview.height);
    gridContext.clearRect(0, 0, this.canvasGrid.width, this.canvasGrid.height);

    drawInlineSVG(this.svgGrid, gridContext, () => {
      const gridData = gridContext.getImageData(0, 0, width, height)

      drawImageSVG(this.imgPreview, previewContext, () => {
        const previewData = previewContext.getImageData(0, 0, width, height)

        let noDiffs = 0
        for (var i = previewData.data.length - 1; i >= 0; i--) {
          if (previewData.data[i] !== gridData.data[i]) {
            noDiffs++
          }
        }
        const diffPercentage = (noDiffs / previewData.data.length) * 100
        console.log("noDiffs", noDiffs, previewData.data.length, diffPercentage)

        if (noDiffs === 0) {
          alert("Goed gedaan!")
        } else {
          alert("Nee, dat klopt niet.")
        }
      })
    })
  }

  handleHover(ev) {
    this.setState({hoverIdx: parseInt(ev.target.dataset.idx, 10)})
  }

  handleMouseLeave(ev) {
    this.setState({hoverIdx: false})
  }

  handleMouseClick(ev) {
    const {selectedIdx, segments} = this.state
    const idx = parseInt(ev.target.dataset.idx, 10)

    ev.preventDefault()

    if (selectedIdx !== false) {
      if (selectedIdx === idx) {
        // stop editing
        return this.setState({selectedIdx: false})
      } else {
        // add new segment
        this.setState({segments: segments.concat([[selectedIdx, idx]])})
      }
    }
    // set new selection
    const {x, y} = this.cursorPoint(ev)
    this.setState({selectedIdx: idx, mousePos: [x, y]})
  }

  handleMouseMove(ev) {
    if (this.state.selectedIdx === false) {
      return false
    }
    ev.preventDefault()
    const {x, y} = this.cursorPoint(ev)
    this.setState({mousePos: [x, y]})
  }

  handleSegmentHover(ev) {

  }

  handleExampleChange(ev) {
    this.setState({example: ev.target.value});
  }

  toggleCode(ev) {
    this.setState({showJSON: !this.state.showJSON})
  }

  pointColor(idx) {
    return this.state.selectedIdx === idx ? "red" : (this.state.hoverIdx === idx ? "green" : "grey")
  }

  renderPoint(point, idx) {
    const {size} = this.state
    return (
      <circle
        cx={point[0]}
        cy={point[1]}
        r={size}
        fill={this.pointColor(idx)}
        key={idx}
        data-idx={idx}
        className="point"
        onMouseEnter={this.handleHover.bind(this)}
        onMouseLeave={this.handleMouseLeave.bind(this)}
        onClick={this.handleMouseClick.bind(this)}
      />
    )
  }

  renderNewSegment() {
    const p1 = this.grid[this.state.selectedIdx]
    const p2 = this.state.mousePos

    return (
      <line
        x1={p1[0]}
        y1={p1[1]}
        x2={p2[0]}
        y2={p2[1]}
        key="newseg"
        strokeWidth={3}
        stroke="purple"
        strokeOpacity={0.5}
      />
    )
  }

  renderSegment(segment, key, color) {
    const p1 = this.grid[segment[0]]
    const p2 = this.grid[segment[1]]

    // console.log(segment, p1, p2)
    return (
      <line
        x1={p1[0]}
        y1={p1[1]}
        x2={p2[0]}
        y2={p2[1]}
        key={key}
        strokeWidth={3}
        stroke={color}
        onMouseEnter={this.handleSegmentHover.bind(this)}
      />
    )
  }

  renderPresetOptions() {
    return this.presets.map((preset, idx) => {
      return <option key={idx} value={preset.name}>{preset.name}</option>
    })
  }


}

Spijkerplank.defaultProps = {
  segments: [],
  rows: 11,
  cols: 11
}

export default Spijkerplank;
