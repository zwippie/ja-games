import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

const NO_ROWS = 5
const NO_COLS = 5
const NO_CELLS = NO_ROWS * NO_COLS

// Return indices where the robot on fromIndex can move to
// given that it must walk to another robot in a row cor column.
function findTargetSpots(cells, fromIndex) {
  if (cells[fromIndex.color] === "") {
    return []
  }

  let result = []

  const fromRow = Math.trunc(fromIndex / NO_COLS)
  const fromCol = fromIndex % NO_COLS

  // left
  let tmpCol = fromCol
  while (--tmpCol >= 0) {
    const tmpIdx = (fromRow * NO_COLS) + tmpCol
    if (cells[tmpIdx].color !== "") {
      if (tmpIdx + 1 !== fromIndex) {
        result.push(tmpIdx + 1)
      }
      break
    }
  }

  // right
  tmpCol = fromCol
  while (++tmpCol < NO_COLS) {
    const tmpIdx = (fromRow * NO_COLS) + tmpCol
    if (cells[tmpIdx].color !== ""){
      if (tmpIdx - 1 !== fromIndex) {
        result.push(tmpIdx - 1)
      }
      break
    }
  }

  // top
  let tmpRow = fromRow
  while (--tmpRow >= 0) {
    const tmpIdx = (tmpRow * NO_COLS) + fromCol
    if (cells[tmpIdx].color !== "") {
      if (tmpIdx + NO_COLS !== fromIndex) {
        result.push(tmpIdx + NO_COLS)
      }
      break
    }
  }

  // down
  tmpRow = fromRow
  while (++tmpRow < NO_ROWS) {
    const tmpIdx = (tmpRow * NO_COLS) + fromCol
    if (cells[tmpIdx].color !== "") {
      if (tmpIdx - NO_COLS !== fromIndex) {
        result.push(tmpIdx - NO_COLS)
      }
      break
    }
  }

  return result
}

const robotIconClasses = {
  "red": "glyphicon glyphicon-king",
  "green": "glyphicon glyphicon-asterisk",
  "blue": "glyphicon glyphicon-tint",
  "yellow": "glyphicon glyphicon-sunglasses",
  "purple": "glyphicon glyphicon-plane",
  "orange": "glyphicon glyphicon-flash"
}

class RobotGrid extends React.Component {
  constructor(props) {
    super(props)

    this.state = this.initialState()
  }

  initialState() {
    return({
      cells: this.loadInitialSetup(),
      selectedCellIndex: undefined,
      highlightedCellIndices: [],
      solved: false,
      noMovesMade: 0
    })
  }

  render() {
    const {debug, baseIndex} = this.props
    const {selectedCellIndex, highlightedCellIndices, solved, noMovesMade} = this.state

    const cells = this.state.cells.map((cell) => {
      const contents = debug ? `${cell.index} ${cell.color}` : ""
      const styles = [
        "cell",
        cell.color,
        cell.index === baseIndex ? 'exit' : '',
        cell.index === selectedCellIndex ? 'selected' : '',
        highlightedCellIndices.includes(cell.index) ? 'highlighted' : '',
        robotIconClasses[cell.color]
      ]
      const className = styles.filter(style => style !== '').join(' ')

      return (
        <div className={className} key={cell.index} onClick={this.onCellClick.bind(this, cell)}>
          <span>{contents}</span>
        </div>
      )
    })

    const className = solved ? "grid solved" : "grid"
    let noMovesMadeText = ""
    switch(noMovesMade) {
      case 0: noMovesMadeText = "Geen zetten gedaan"; break;
      case 1: noMovesMadeText = "1 zet gedaan"; break;
      default: noMovesMadeText = `${noMovesMade} zetten gedaan`
    }
    if (solved) {
      noMovesMadeText = `Goed gedaan! Opgelost in ${noMovesMade} zetten.`
    }

    return (
      <div>
        <div className={className}>
          {cells}
        </div>
        <div className="btn-toolbar">
          <button className="btn" onClick={this.reset.bind(this)}>Reset</button>
          <button className="btn" onClick={this.newGame.bind(this)}>Nieuwe puzzel</button>
          <span className="no_moves">{noMovesMadeText}</span>
        </div>
      </div>
    )
  }

  onCellClick(clickedCell, event) {
    const {baseIndex} = this.props
    const {cells, selectedCellIndex, highlightedCellIndices, solved, noMovesMade} = this.state

    // Nothing more to do
    if (solved) {
      return
    }

    // Deselect current selected cell
    if (selectedCellIndex === clickedCell.index) {
      this.setState({
        selectedCellIndex: undefined,
        highlightedCellIndices: []
      })
      return
    }

    // Move to target
    if (selectedCellIndex !== undefined && highlightedCellIndices.includes(clickedCell.index)) {
      console.log("Move to", clickedCell.index)
      const newColor = cells[selectedCellIndex].color
      const newCells = cells.map((cell) => {
        if (cell.index === selectedCellIndex) {
          cell.color = ""
        }
        if (cell.index === clickedCell.index) {
          cell.color = newColor
        }
        return cell
      })
      const solved = (baseIndex === clickedCell.index) && (newColor === "red")

      this.setState({
        selectedCellIndex: undefined,
        highlightedCellIndices: [],
        cells: newCells,
        solved: solved,
        noMovesMade: noMovesMade + 1
      })
      return
    }

    // Select cell and show target spots
    if (clickedCell.color !== "") {
      const targetSpots = findTargetSpots(cells, clickedCell.index)
      console.log(clickedCell, targetSpots)
      this.setState({
        selectedCellIndex: clickedCell.index,
        highlightedCellIndices: targetSpots
      })
    }
  }

  reset() {
    this.setState({
      cells: this.loadInitialSetup(),
      selectedCellIndex: undefined,
      highlightedCellIndices: [],
      solved: false,
      noMovesMade: 0
    })
  }

  newGame() {
    window.location.reload()
  }

  loadInitialSetup() {
    const {initialSetup} = this.props

    // Empty cells
    let cells = Array(NO_CELLS).fill().map((x,i) => {
      return {index: i, color: ""}
    })

    // Load initial puzzle setup
    initialSetup.forEach((cell) => {
      cells[cell.index].color = cell.color
    })

    return cells
  }
}

RobotGrid.propTypes = {
  initialSetup: PropTypes.array.isRequired,
  baseIndex: PropTypes.number,
  debug: PropTypes.bool
}

RobotGrid.defaultProps = {
  baseIndex: 12,
  debug: false
}

export default RobotGrid
