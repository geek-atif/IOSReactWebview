import React, { useCallback, useEffect, useState } from 'react'
import './Home.css';

const Home = () => {
    
    const [dataFromIOS, setDataFromIOS] = useState('')

    useEffect(() => {

        // Adding event for IOS app
        window.addEventListener('iosEvent', iosEventHandler);

        return () =>
            window.removeEventListener('iosEvent', iosEventHandler);
    }, [])

    const iosEventHandler = useCallback(
        (e) => {
            console.log("Received data from IOS : "+ e.detail.data);
            setDataFromIOS(e.detail.data);
            
        },
        [setDataFromIOS]
    )

    const onClickHandler = (name) => {

      console.log("Sending data to IOS : " +name);
        // Sending Data to IOS App
        window?.webkit?.messageHandlers?.IOS_BRIDGE?.postMessage({
            message: name,
        });
    }
    

    const names = ['Atif', 'Jane', 'Vicky', 'Alice', 'Raj'];


    return (
            
        <div className="app-container">
      <header className="header">
        <h1>React iOS Communication</h1>
      </header>
      <main className="main-content">
        <h2>Click on the name to send to the iOS app</h2>
        <ul>
          {names.map((name) => (
            <li key={name} onClick={() => onClickHandler(name)}>
              {name}
            </li>
          ))}
        </ul>
        {dataFromIOS && (
          <div className="response">Message From IOS App : {dataFromIOS}</div>
        )}
      </main>
      <footer className="footer">
        <p>&copy; 2024 AtifTech</p>
      </footer>
    </div>
       
      );

}

export default Home
