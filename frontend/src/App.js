import React, { Component } from "react";
import getWeb3 from "./getWeb3";
import './App.css';
import PokemonABI from "./contracts/PokemonABI.json";
import PokeballABI from "./contracts/PokeballABI.json";
import ContractAddress from "./contracts/contract-address.json";
import { BigNumber } from "ethers";

class App extends Component {
  state = {
    web3: null,
    accounts: null,
    pokemonInstance: null,
    pokeballInstance: null
  }

  componentDidMount = async () => {
    try {
      const web3 = await getWeb3();
      const accounts = await web3.eth.getAccounts();
      const pokemonInstance = new web3.eth.Contract(
        PokemonABI.abi,
        ContractAddress.Pokemon
      )
      const pokeballInstance = new web3.eth.Contract(
        PokeballABI.abi,
        ContractAddress.Pokeball
      )

      this.setState({
        web3, accounts, pokemonInstance: pokemonInstance, pokeballInstance: pokeballInstance
      })

    } catch (error) {
      alert(error);
      console.error(error);
    }
  }
  render() {
    return (
      <div className="App">
        <div>
          <input id="pokemonNameInput" type="text" placeholder="Pokemon Name"></input>
          <button id="catchPokemon" type="submit" onClick={this.catchPokemon}>Catch Pokemon</button>
        </div>
        <div>
          <input id="buyPokeballId" type="text" placeholder="Pokeball ID"></input>
          <input id="buyPokeballAmount" type="text" placeholder="Pokeball Amount"></input>
          <button id="buyPokeballButton" type="submit" onClick={this.buyPokeball}>Buy Pokeball</button>
        </div>
      </div>
    );
  }

  catchPokemon = async () => {
    const { accounts, pokemonInstance } = this.state;
    // const pokemonName = document.getElementById("pokemonNameInput").value;
    const tokenURICall = await pokemonInstance.methods.setTokenIdToTokenURI(0, "").send({ from: accounts[0] })
    console.log(tokenURICall.events.UpdatedTokenURI.returnValues)
    // const call = await pokemonInstance.methods.catchPokemon(pokemonName).call();
    // console.log(call)
  }

  buyPokeball = async () => {
    const { accounts, pokeballInstance } = this.state;
    const pokeballID = document.getElementById("buyPokeballId").value;
    const pokeballAmount = document.getElementById("buyPokeballAmount").value;

    const pokeballPrice = await pokeballInstance.methods.tokenIdToTokenPrice(pokeballID).call()
    console.log(pokeballPrice)

    const totalPrice = BigNumber.from(pokeballPrice) * BigNumber.from(pokeballAmount)
    console.log(totalPrice)
    // const value = utils.parseEther(totalPrice.toString())
    const buyPokeballCall = await pokeballInstance.methods.buyPokeball(accounts[0], pokeballID, pokeballAmount).send({from: accounts[0], value: totalPrice})
    console.log(buyPokeballCall)
  }

}

export default App;
