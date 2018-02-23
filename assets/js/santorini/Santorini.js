import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

const NO_ROWS = 5
const NO_COLS = 5
const NO_CELLS = NO_ROWS * NO_COLS

const PLAYER_COLORS = ["#c11717", "#c9c91a"]

class Santorini extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      players: [{id: "11", color: 0, index: 0}, {id: "21", color: 1, index: 14}],
      cells: this.loadInitialSetup()
    }
  }

  render() {
    const {players, cells} = this.state
    const board = cells.map((cell) => {
      const contents = cell.level
      const styles = [
        "cell"
      ]
      const className = styles.filter(style => style !== '').join(' ')

      // Draw buildings
      let buildings = []
      if (cell.level >= 1) {
        buildings.push(<rect key="level1" height="108" width="108" y="6" x="6" strokeWidth="5" stroke="#000000" fill="#b2b2b2"/>)
      }
      if (cell.level >= 2) {
        buildings.push(<rect key="level2" height="84" width="84" y="18" x="18" strokeWidth="5" stroke="#000000" fill="#cccccc"/>)
      }
      if (cell.roof) {
        buildings.push(<circle key="roof" r="34" cy="60" cx="60" strokeWidth="5" stroke="#000000" fill="#005fbf"/>)
      } else if (cell.level >= 3) {
        buildings.push(<circle key="level3" r="34" cy="60" cx="60" strokeWidth="5" stroke="#000000" fill="#e5e5e5"/>)
      }

      // Draw player
      const player = players.find(player => player.index == cell.index)
      if (player) {
        const color = PLAYER_COLORS[player.color]
        const id = `player-${player.id}`
        buildings.push(<rect id={id} className="player" stroke="#000000" transform="rotate(45,60,60)" height="40" width="40" y="40" x="40" strokeWidth="5" fill={color}/>)
      }

      return (
        <svg className={className} key={cell.index}
            onClick={this.onCellClick.bind(this, cell)}
            height="120" width="120">
          {buildings}
        </svg>
      )
    })

    return (
      <div id="santorini">
        <div className="board">
          {board}
        </div>
      </div>
    )
  }

  onCellClick(cell, event) {
    event.preventDefault()
    console.log(cell)
    this.upgradeCell(cell.index)
  }

  upgradeCell(index) {
    const {cells} = this.state
    const cell = cells[index]
    const newRoof = cell.level == 3 ? true : cell.roof
    const newLevel = Math.min(cell.level + 1, 3)
    const newCell = {index: index, level: newLevel, roof: newRoof}
    const newCells = cells.map(c => c.index == index ? newCell : c)
    this.setState({
      cells: newCells
    })
  }

  loadInitialSetup() {
    // Empty cells
    let cells = Array(NO_CELLS).fill().map((x,i) => {
      return {index: i, level: 0, roof: false}
    })

    return cells
  }
}

export default Santorini
