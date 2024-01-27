import React, { useCallback, useEffect, useState } from 'react'
import './Home.css';

const Home = () => {
    
    const [dataFromIOS, setDataFromIOS] = useState('')

    useEffect(() => {

        window.addEventListener('iosEvent', iosEventHandler);

        return () =>
            window.removeEventListener('iosEvent', iosEventHandler);
    }, [])

    const iosEventHandler = useCallback(
        (e) => {
            alert(e.detail.data);
            console.log(e.detail.data);
            setDataFromIOS(e.detail.data);
        },
        [setDataFromIOS]
    )

    const onClickHandler = (name) => {
        // Sending Data to IOS
        window?.webkit?.messageHandlers?.IOS_BRIDGE?.postMessage({
            message: "Hello! I'm React. "+name,
        });
    }

    

    const names = ['Atif', 'Jane', 'Vicky', 'Alice', 'Raj'];

    

    return (
            
        <div>
          <h2>Click on the name to send to the IOS app </h2>
          <ul>
            {names.map((name) => (
              <li key={name} onClick={() => onClickHandler(name)}>
                {name}
              </li>
            ))}
          </ul>
          <div className="home">{dataFromIOS}</div>
        </div>
       
      );

}

export default Home
