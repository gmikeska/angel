import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="component"
export default class extends Controller {
  static targets = [ ]
  static outlets = [ ]
  static values = {
    loading: { type:Boolean, default: true }
  }
  static get isLoaded() {
    return (!this.loadingValue)
  }
  loaded(){
    this.loadingValue = false

  }
  loading(){
    this.loadingValue = true

  }
  connect() {
    debugger
  }
}
