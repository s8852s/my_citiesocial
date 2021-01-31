import { Controller } from 'stimulus'
import Rails from '@rails/ujs';

export default class extends Controller {
  static targets = [ "email" ]

  add(event){
    event.preventDefault();

    let email = this.emailTarget.value.trim();
    let data = new FormData();
    data.append("subscribe[email]", email);
    Rails.ajax({
      url: '/api/v1/subscribe',
      type: 'POST',
      dataType: 'json',
      data: data,
      success: (response) => {
        switch (response.status){
          case 'ok':
            alert('完成訂閱');
            this.emailTarget.value = '';
            break;

          case 'duplicated':
            alert(`${response.email} 已經訂閱過了`);
            break;
        }
      },
      error: (err) =>{
        console.log(err);
      }
    })
  }

  connect(){
    console.log("hi");
  }

}