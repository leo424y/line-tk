import { Controller } from "stimulus"

export default class extends Controller {
    connect() {
        document.addEventListener("autocomplete.change", this.autocomplete.bind(this))
    }

    autocomplete(event) {
        console.log(event);
    }
}
