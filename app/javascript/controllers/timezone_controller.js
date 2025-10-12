import { Controller } from "@hotwired/stimulus"

// Sets a `tz` cookie with the browser's IANA time zone so the server can use it per request.
export default class extends Controller {
  connect() {
    try {
      const tz = Intl.DateTimeFormat().resolvedOptions().timeZone
      if (!tz) return
      const encoded = encodeURIComponent(tz)
      const current = this.currentCookieValue("tz")
      if (current !== encoded) {
        document.cookie = `tz=${encoded}; path=/; max-age=${60 * 60 * 24 * 365}`
      }
    } catch (_e) {
      // no-op
    }
  }

  currentCookieValue(name) {
    const prefix = name + "="
    const found = document.cookie.split("; ").find((row) => row.startsWith(prefix))
    return found ? encodeURIComponent(found.slice(prefix.length)) : null
  }
}
