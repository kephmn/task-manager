import { Controller } from "@hotwired/stimulus"

// Connects to elements with data-controller="due-date"
export default class extends Controller {
  static values = {due: String}

  connect() {
    // Runs once when the element appears on the page (including
    // when Turbo Streams inserts a new task into the DOM live)
    this.update()
    / Re-check every 60s so "Due in 5 min" naturally becomes
    // "Overdue" without needing a page refresh
    this.interval = setInterval(() => this.update(), 60000)
  }

  disconnect() {
    // Cleans up the timer when the element is removed (e.g. task
    // deleted via Turbo Stream) — prevents a memory leak from an
    // orphaned interval still running in the background
    clearInterval(this.interval)
  }

  update() {
    const due = new Date(this.dueValue)
    const now = new Date()
    const diffMs = due - now

    if (diffMs < 0) {
      this.element.textContent = "Overdue"
      this.element.classList.add("text-red-600")
    } else {
      const hours = Math.round(diffMs / 1000 / 60 / 60)
      this.element.textContent = hours < 24 ? `Due in ${hours}h` : `Due ${due.toLocaleDateString()}`
    }
  }
}
