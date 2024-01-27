import './App.css';
import Home from './Home';
import { Route, BrowserRouter as Router, Routes } from 'react-router-dom';

function App() {
  return (
    <Router>
        <Routes>
          <Route exact path='/home' element={<Home />} />
        </Routes>
      </Router>
  );
}

export default App;
