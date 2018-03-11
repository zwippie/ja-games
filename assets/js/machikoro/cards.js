export default [
  {
    name: "Graanveld",
    dice: [1],
    type: "Goederen",
    cost: 1,
    text: "Ontvang 1 munt van de bank ongeacht wiens beurt het is.",
    action: {
      amount: 1,
      from: "bank",
      when: "always"
    }
  },
  {
    name: "Veehouderij",
    dice: [2],
    type: "Dieren",
    cost: 1,
    text: "Ontvang 1 munt van de bank ongeacht wiens beurt het is.",
    action: {
      amount: 1,
      from: "bank",
      when: "always"
    }
  },
  {
    name: "Bakkerij",
    dice: [2, 3],
    type: "Winkel",
    cost: 1,
    text: "Ontvang 1 munt van de bank als het jouw beurt is.",
    action: {
      amount: 1,
      from: "bank",
      when: "ownTurn"
    }
  },
  {
    name: "Cafe",
    dice: [3],
    type: "Horeca",
    cost: 2,
    text: "Ontvang 1 munt van iedere speler die dit getal gooit.",
    action: {
      amount: 1,
      from: "activePlayer",
      when: "always"
    }
  },
  {
    name: "Stadion",
    dice: [6],
    type: "Groot gebouw",
    cost: 6,
    text: "Ontvang 2 munten van iedere speler als het jouw beurt is.",
    action: {
      amount: 2,
      from: "everyone",
      when: "ownTurn"
    }
  }
]
