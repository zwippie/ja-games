import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

const NO_ROWS = 5
const NO_COLS = 5
const NO_CELLS = NO_ROWS * NO_COLS

const PLAYER_COLORS = ["#ff3860", "#ffdd57"]
const PLAYER_NAMES = ["RED", "YELLOW"]
const PLAYER_INSTRUCTION_CLASS = ["notification is-danger", "notification is-warning"]

function findValidTargetCells(cells, fromIndex, players) {
  const fromRow = Math.trunc(fromIndex / NO_COLS)
  const fromCol = fromIndex % NO_COLS
  const playerIndices = players.map(p => p.index)

  let targets = []
  // left
  if (fromCol > 0) {
    targets.push(fromIndex - 1)
    if (fromRow > 0) {
      targets.push(fromIndex - NO_COLS - 1)
    }
    if (fromRow < NO_ROWS - 1) {
      targets.push(fromIndex + NO_COLS - 1)
    }
  }
  // center
  if (fromRow > 0) {
    targets.push(fromIndex - NO_COLS)
  }
  if (fromRow < NO_ROWS - 1) {
    targets.push(fromIndex + NO_COLS)
  }
  // right
  if (fromCol < NO_COLS - 1) {
    targets.push(fromIndex + 1)
    if (fromRow > 0) {
      targets.push(fromIndex - NO_COLS + 1)
    }
    if (fromRow < NO_ROWS - 1) {
      targets.push(fromIndex + NO_COLS + 1)
    }
  }

  // filter out building that are too high or have a roof or a player
  const fromCell = cells[fromIndex]
  return targets.filter(targetIdx => {
    const targetCell = cells[targetIdx]
    if (targetCell.roof) {
      return false
    }
    if (playerIndices.includes(targetIdx)) {
      return false
    }
    if (targetCell.level - fromCell.level > 1) {
      return false
    }
    return true
  })
}

function getRandomSubarray(arr, size) {
  let shuffled = arr.slice(0), i = arr.length, temp, index
  while (i--) {
    index = Math.floor((i + 1) * Math.random())
    temp = shuffled[index]
    shuffled[index] = shuffled[i]
    shuffled[i] = temp
  }
  return shuffled.slice(0, size)
}

class Santorini extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      players: this.placeRandomPawns(),
      cells: this.loadInitialSetup(),
      gamePhase: "select_pawn_to_move",
      activePlayer: 0,
      selectedCell: false,
      highlightedCells: []
    }
  }

  render() {
    const {players, activePlayer, cells, selectedCell, highlightedCells} = this.state

    const board = cells.map((cell) => {
      const contents = cell.level
      const styles = [
        "cell",
        selectedCell == cell.index ? "selected" : "",
        highlightedCells.includes(cell.index) ? "highlighted" : ""
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

      // Draw players
      players.filter(player => player.index == cell.index).forEach(player => {
        const color = PLAYER_COLORS[player.color]
        const id = `player-${player.id}`
        const playerStyle = [
          "player",
          player.color === activePlayer ? "active" : ""
        ].filter(style => style !== "").join(" ")

        buildings.push(<rect id={id} key={id} className={playerStyle} stroke="#000000" transform="rotate(45,60,60)" height="40" width="40" y="40" x="40" strokeWidth="5" fill={color}/>)
      })

      return (
        <svg className={className} key={cell.index}
            onClick={this.onCellClick.bind(this, cell)}
            height="120" width="120">
          {buildings}
        </svg>
      )
    })

    const instructions = this.getInstructions()
    const instructionsClass = PLAYER_INSTRUCTION_CLASS[activePlayer]

    return (
      <div id="santorini">
        <div className="board">
          {board}
        </div>
        <div className={instructionsClass}>{instructions}</div>
      </div>
    )
  }

  onCellClick(cell, event) {
    event.preventDefault()
    console.log(cell)

    const {players, cells, gamePhase, activePlayer, selectedCell, highlightedCells} = this.state

    if (gamePhase === "select_pawn_to_move") {
      const player = players.find(player => player.index == cell.index)
      if (player && player.color == activePlayer) {
        // Select player cell, highlight valid target cells
        this.setState({
          highlightedCells: findValidTargetCells(cells, cell.index, players),
          selectedCell: cell.index,
          gamePhase: "move_to_cell"
        })
      } else {
        // DEBUG HELPER: remove this when done
        // this.upgradeCell(cell.index)
      }
    } else if (gamePhase === "move_to_cell") {
      if (cell.index === selectedCell) {
        // Deselect current selected cell
        this.setState({
          highlightedCells: [],
          selectedCell: false,
          gamePhase: "select_pawn_to_move"
        })
      } else if (highlightedCells.includes(cell.index)) {
        // Move pawn to target cell and highlight cells that can be build on
        // const player = players.find(p => p.index === selectedCell)
        const newPlayers = players.map(p => p.index !== selectedCell ? p : Object.assign(p, {index: cell.index}))
        if (cell.level === 3) {
          // GAME OVER! Move pawn and end game
          this.setState({
            highlightedCells: [],
            selectedCell: false,
            gamePhase: "you_have_won_the_game",
            players: newPlayers
          })
        } else {
          // Move pawn
          this.setState({
            highlightedCells: findValidTargetCells(cells, cell.index, players),
            selectedCell: false,
            gamePhase: "select_building_spot",
            players: newPlayers
          })
        }
      }
    } else if (gamePhase === "select_building_spot") {
      if (highlightedCells.includes(cell.index)) {
        this.upgradeCell(cell.index)
        this.setState({
          highlightedCells: [],
          gamePhase: "select_pawn_to_move",
          activePlayer: (activePlayer + 1) % 2
        })
      }
    } else if (gamePhase === "you_have_won_the_game") {
      return false
    }
  }

  upgradeCell(index) {
    const {cells} = this.state
    const cell = cells[index]
    const newRoof = cell.level == 3 ? true : cell.roof
    const newLevel = Math.min(cell.level + 1, 3)
    const newCell = {index: index, level: newLevel, roof: newRoof}
    const newCells = cells.map(c => c.index === index ? newCell : c)
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

  placeRandomPawns() {
    const indices = getRandomSubarray(Array(NO_CELLS).fill().map((x,i) => i), PLAYER_NAMES.length * 2)
    return [
      {id: "11", color: 0, index: indices[0]},
      {id: "21", color: 1, index: indices[1]},
      {id: "12", color: 0, index: indices[2]},
      {id: "22", color: 1, index: indices[3]}
    ]
  }

  getInstructions() {
    const {activePlayer, gamePhase} = this.state
    const activePlayerString = PLAYER_NAMES[activePlayer]
    const gamePhaseString = gamePhase.replace(/\_/g, ' ')

    return `Player ${activePlayerString}, ${gamePhaseString}.`
  }
}

export default Santorini
