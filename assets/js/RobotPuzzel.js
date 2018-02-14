import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

import RobotGrid from './RobotGrid.js'

class RobotPuzzel extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      setup: props.initialSetup,
      debug: false
    }

    this.handleDebugChange = this.handleDebugChange.bind(this);
    this.handleNewGame = this.handleNewGame.bind(this);
  }

  handleDebugChange(event) {
    this.setState({debug: event.target.checked})
  }

  handleNewGame() {
    fetch("/api/lunar_landing")
      .then(response => response.json())
      .then(data => this.setState({setup: data.grid}))
  }

  render() {
    const {debug, setup} = this.state

    return (
      <div id="lunar_landing">
        <RobotGrid initialSetup={setup} debug={debug} onNewGame={this.handleNewGame} />
        <label>
          <input type="checkbox" checked={debug} onChange={this.handleDebugChange} />
          Debug
        </label>
      </div>
    )
  }
}

RobotPuzzel.propTypes = {
  initialSetup: PropTypes.array
}

RobotPuzzel.defaultProps = {
  initialSetup: [
    {color: "red", index: 10},
    {color: "blue", index: 18},
    {color: "green", index: 1},
    {color: "purple", index: 22},
    {color: "orange", index: 3}
  ]
}

export default RobotPuzzel
