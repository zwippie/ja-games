import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

import RobotGrid from './RobotGrid.js'

class RobotPuzzel extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      debug: false
    }

    this.handleDebugChange = this.handleDebugChange.bind(this);
  }

  handleDebugChange(event) {
    this.setState({debug: event.target.checked})
  }

  render() {
    const {debug} = this.state
    const {initialSetup} = this.props

    // const initialSetup = [
    //   {color: "red", index: 10},
    //   {color: "blue", index: 18},
    //   {color: "green", index: 1},
    //   {color: "purple", index: 22},
    //   {color: "orange", index: 3}
    // ]

    return (
      <div id="robot_puzzel">
        <h1>RobotPuzzel</h1>
        <RobotGrid initialSetup={initialSetup} debug={debug} />
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
