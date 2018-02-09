import React from 'react'
import ReactDOM from 'react-dom'

const buildingCost = (base, level) => Math.trunc(base * (level ** 1.5))

class Klikker extends React.Component {

  constructor(props) {
    super(props)
    this.state = {
      clicks: 0,
      saldo: 0,
      modifiers: 0,
      multipliers: 1,
      autoClick: 0,
      buildings: [
        {name: "Hout", id: "wood", baseCost: 10, level: 0, effect: "modifier", value: 1, image: "boomstam.png"},
        {name: "Kool", id: "coal", baseCost: 50, level: 0, effect: "multiplier", value: 1, image: "kool.png"},
        {name: "Robots", id: "robots", baseCost: 500, level: 0, effect: "autoClick", value: 0.1, image: "robot.png"},
        {name: "Boom", id: "tree", baseCost: 5000, level: 0, effect: "modifier", value: 10, image: "boom.png"},
        {name: "Mijn", id: "mine", baseCost: 5000, level: 0, effect: "multiplier", value: 10, image: "mijn.png"},
        {name: "Ster", id: "star", baseCost: 500000, level: 0, effect: "", value: 0, image: "ster.png" }
      ]
    }
  }

  handleClick() {
    const {saldo, clicks, modifiers, multipliers} = this.state
    this.setState({
      clicks: clicks + 1,
      saldo: Math.round(saldo + ((1 + modifiers) * multipliers))
    })
  }

  preventZoom(e) {
    let t2 = e.timeStamp
    let t1 = e.currentTarget.dataset.lastTouch || t2
    let dt = t2 - t1
    let fingers = e.touches.length
    e.currentTarget.dataset.lastTouch = t2

    if (!dt || dt > 500 || fingers > 1) return // not double-tap

    e.preventDefault()
    this.handleClick()
  }

  autoClick() {
    this.handleClick()
    setTimeout(() => this.autoClick(), (1 / this.state.autoClick) * 1000)
  }

  buyBuilding(building) {
    const {saldo, modifiers, multipliers, autoClick, buildings} = this.state
    const price = buildingCost(building.baseCost, building.level + 1)


    if (price && saldo >= price) {
      let newBuilding = Object.assign({}, building, {level: building.level + 1});
      buildings[buildings.indexOf(building)] = newBuilding

      if (building.effect == "modifier") {
        this.setState({
          modifiers: Math.round((modifiers + building.value) * 10) / 10,
          saldo: saldo - price,
          buildings: buildings
        })
      } else if (building.effect == "autoClick") {
        if (autoClick === 0) {
          this.autoClick()
        }
        this.setState({
          autoClick: Math.round((autoClick + building.value) * 10) / 10,
          saldo: saldo - price,
          buildings: buildings
        })
      } else {
        this.setState({
          multipliers: Math.round((multipliers + building.value) * 10) / 10,
          saldo: saldo - price,
          buildings: buildings
        })
      }
    }
  }

  render() {
    const {saldo, clicks, modifiers, multipliers, autoClick} = this.state

    const buildings = this.state.buildings.map((building) => {
      const price = buildingCost(building.baseCost, building.level + 1)
      const isDisabled = saldo < price

      return(
        <div className="building" key={building.name}>
          <img src={"images/" + building.image}/>
          <strong>{building.name}</strong> (level {building.level})
          <button disabled={isDisabled} onClick={() => this.buyBuilding(building)}>Upgrade naar level {building.level + 1} voor {price}</button>
        </div>
      )
    })

    return (
      <div className="klikker">
        <div className="topbar">
          <div>Saldo: {saldo}</div>
          <div>Clicks: {clicks}</div>
          <div>Modifiers: {modifiers}</div>
          <div>Multipliers: {multipliers}</div>
          <div>Auto-click: {autoClick}</div>
        </div>
        <button className="clicker" onClick={() => this.handleClick()} onTouchStart={(ev) => this.preventZoom(ev)}></button>
        <div className="buildings">{buildings}</div>
      </div>
    )
  }
}

export default Klikker
