import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="previews"
export default class extends Controller {
  static targets = ["input", "previewContainer"]

  preview() {
    const files = this.inputTarget.files
    const container = this.previewContainerTarget

    container.innerHTML = ""

    Array.from(files).forEach((file,i) => {
      const reader = new FileReader()
      reader.onloadend = () => {
        const img = document.createElement("img")
        img.src = reader.result
        img.id = "preview-image-" + i
        img.classList.add("img-fluid", "object-fit-cover")
        img.style.width = "100%"
        img.style.maxHeight = "100%"

        const wrapper = document.createElement("div")
        wrapper.classList.add("ratio", "ratio-16x9", "mb-2")
        wrapper.appendChild(img)
        container.appendChild(wrapper)
      }
      reader.readAsDataURL(file)
    })
  }
}
