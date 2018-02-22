
const presetsUrl = "/api/spijkerplanken"

class ServerPresets {
  constructor() {
    this.presets = [{
      "name": "Kies een voorbeeld...",
      "segments": []
    }]
    this.fetchPresets()
  }

  fetchPresets() {
    let self = this
    fetch(presetsUrl).then(function(response) {
      return response.json();
    }).then(function(data) {
      self.presets = data
    });
  }
}

export default ServerPresets
