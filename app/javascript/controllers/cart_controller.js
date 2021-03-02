import { Controller } from "stimulus" 

export default class extends Controller { 
  static targets = [ "count" ] 

  updateCart(evt) {
    console.log(evt, "cart");
    let data = evt.detail;
    this.countTarget.innerText = `(${data.item_count})`;
    
  }
}

