import { Controller } from "@hotwired/stimulus"

// Keeps a scrollable element anchored to the bottom like a chat window.
export default class extends Controller {
  connect() {
    this.scrollToBottom()
    // Observe DOM changes to auto-scroll when new messages arrive if near bottom
    this.observer = new MutationObserver(() => {
      if (this.isNearBottom()) this.scrollToBottom()
    })
    this.observer.observe(this.element, { childList: true, subtree: true })

    this._onFrameLoad = () => this.scrollToBottom()
    document.addEventListener("turbo:frame-load", this._onFrameLoad)
  }

  disconnect() {
    if (this.observer) this.observer.disconnect()
    if (this._onFrameLoad) document.removeEventListener("turbo:frame-load", this._onFrameLoad)
  }

  scrollToBottom() {
    this.element.scrollTop = this.element.scrollHeight
  }

  isNearBottom(threshold = 48) {
    const { scrollTop, clientHeight, scrollHeight } = this.element
    return scrollHeight - (scrollTop + clientHeight) <= threshold
  }
}
