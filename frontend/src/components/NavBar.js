import React from "react";
import RoundButton from "./RoundButton";

function NavBar(props) {

    return (
        <div style={{ alignItems: 'center', justifyContent: 'space-between', display: 'flex', padding: 16 }}>
            <img src={require('../assets/pokemon-logo-png.png')} alt="Item" style={{ width: 150 }}></img>
            <button style={{ height: 40, borderRadius: '8px', backgroundColor: '#dc483f', color: 'white', fontSize: '12px', padding: '10px', border: 'none' }}>
                Connect Wallet
            </button>
        </div>
    );

}

export default NavBar;
