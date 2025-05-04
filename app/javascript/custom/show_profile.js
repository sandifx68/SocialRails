function modalShower(elementId, modal) {
    const desc = document.getElementById(elementId);
    const modalElement = document.getElementById(modal);
  
    console.log(desc, modalElement)
    if (desc && modalElement) {
      const modal = new bootstrap.Modal(modalElement);
      console.log("Found!")
      desc.addEventListener("click", () => {
        console.log("Pressed")
        modal.show();
      });
    }
}

document.addEventListener("DOMContentLoaded", () => modalShower("user-description","description-modal"));
//document.addEventListener("DOMContentLoaded", () => f("user-banner","bannerModal"));
//document.addEventListener("DOMContentLoaded", () => f("user-pfp","pfpModal"));
  