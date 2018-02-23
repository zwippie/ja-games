// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"
import "react-phoenix"

import Klikker from "./klikker.js"
import RobotPuzzel from "./RobotPuzzel.js"
// import presets from "./spijkerplank/presets.js"
import Spijkerplank from "./spijkerplank/Spijkerplank.js"
import Santorini from "./santorini/Santorini.js"
// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

// import React from "react"
// import ReactDOM from "react-dom"

// ReactDOM.render(
//   <Klikker name="jaja"/>,
//   document.getElementById("main")
// );


// Expose all mountable components to phoenix-react's
// react_component view function.
window.Components = {
  Klikker,
  RobotPuzzel,
  Spijkerplank,
  Santorini
}

// Bulma hamburger menu
document.addEventListener('DOMContentLoaded', function () {

  // Get all "navbar-burger" elements
  var $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);

  // Check if there are any navbar burgers
  if ($navbarBurgers.length > 0) {

    // Add a click event on each of them
    $navbarBurgers.forEach(function ($el) {
      $el.addEventListener('click', function () {

        // Get the target from the "data-target" attribute
        var target = $el.dataset.target;
        var $target = document.getElementById(target);

        // Toggle the class on both the "navbar-burger" and the "navbar-menu"
        $el.classList.toggle('is-active');
        $target.classList.toggle('is-active');

      });
    });
  }

});
