import React, { Component } from "react";
import getWeb3 from "./getWeb3";
import './App.css';

var accounts;
class App extends Component {
  state = {
    web3: null,
    accounts: null,
  }

  componentDidMount = async () => {
    try {
      const web3 = await getWeb3();
      accounts = await web3.eth.getAccounts();
      this.setState({
        web3, accounts
      })
    } catch (error) {
      alert(error);
      console.error(error);
    }
  }
  render() {
    return (
      <div className="App">
        Pokemon Battle
      </div>
    );
  }
}

export default App;
