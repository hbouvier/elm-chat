import './main.css';
import { Elm } from './Main.elm';
import config from './config';
import registerServiceWorker from './registerServiceWorker';

fetch(config.URL + "/latest", {
    headers: {
        "secret-key": config.SECRET
    }
})
.then(res =>res.json())
.then(json => {
  const app = Elm.Main.init({
    node: document.getElementById('root')
  });
  console.log('app:', app);




    // app.ports.setStorage.subscribe(function(state) {
    //   console.log('state:', state)
    //     // fetch(config.URL, {
    //     //     method: "PUT",
    //     //     headers: {
    //     //         "content-type": "application/json",
    //     //         "secret-key": config.SECRET
    //     //     },
    //     //     body: JSON.stringify(state)
    //     // });
    // });
});


registerServiceWorker();
