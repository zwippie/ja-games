import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

// const svgDiceBorder = <rect x="-1.42383" ry="5" rx="5" id="svg_5" height="120" width="120" stroke-linecap="null" stroke-linejoin="null" stroke-dasharray="null" stroke-width="5" stroke="#000000" fill="#ffffff"/>
// const svgDiceEyes = <circle stroke="#ffffff" id="svg_1" r="12" cy="60" cx="60" stroke-width="5" fill="#000000"/>


const diceCoords = [
  [[60, 60]],
  [[90, 30], [30, 90]],
  [[60, 60], [90, 30], [30, 90]],
  [[30, 30], [90, 30], [30, 90], [90, 90]],
  [[60, 60], [30, 30], [90, 30], [30, 90], [90, 90]],
  [[85, 25], [35, 95], [85, 95], [35, 25], [85, 60], [35, 60]]
]

const randomDice = function(count) {
  let dice = []
  for (var i = 0; i < count; i++) {
    dice.push(Math.floor(Math.random() * 6) + 1)
  }
  return dice;
}

class Dobbelen extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      name: "",
      number: 4,
      randomDice: [],
      value: null
    }
  }

  render() {
    if (this.state.name === "") {
      return (
        <div>
          <input type="text" placeholder="Wat is je naam?" ref={(input) => this.input = input} />
          <button type="button" onClick={(ev) => this.setName(ev)}>Ok</button>
        </div>
      )
    }

    const eyes = diceCoords[this.state.number - 1].map((eye, idx) => {
      return <circle key={idx} stroke="#ffffff" r="12" cx={eye[0]} cy={eye[1]} strokeWidth="5" fill="#000000"/>
    })

    const numberButtons = [1,2,3,4,5,6].map(number => {
      return <button key={number} onClick={(ev) => this.setValue(ev)}>{number}</button>
    })

    return (
      <div id="dobbelen">
        <svg width="120" height="120" id="dice" onClick={() => this.rollDice()}>
          <g>
            <rect x="0" ry="5" rx="5" id="svg_5" height="120" width="120" strokeLinecap="null" strokeLinejoin="null" strokeDasharray="null" strokeWidth="5" stroke="#000000" fill="#ffffff"/>
            {eyes}
          </g>
        </svg>
        <div>
          {this.state.value !== null ? `Ok ${this.state.name}, gooi maar eens ${this.state.value}` : numberButtons}
        </div>
      </div>
    )
  }

  setName(ev) {
    this.setState({
      name: this.input.value
    })
  }

  setValue(ev) {
    this.setState({
      value: parseInt(ev.target.innerText)
    })
  }

  rollDice() {
    const {name, value} = this.state
    const number = (name.toUpperCase() === "JELLE" ? value : Math.floor(Math.random() * 6) + 1)
    this.setState({
      number: number,
      randomDice: randomDice(10),
      value: null
    })
    // setTimeout(() => this.nextRandomDice().bind(this), 250)
  }

  nextRandomDice() {
    if (this.state.randomDice.length > 0) {
      this.setState({
        randomDice: this.state.randomDice.slice(1),
        number: this.state.randomDice[0]
      })
    }
  }

}

export default Dobbelen
