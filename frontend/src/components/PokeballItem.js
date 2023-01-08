import React from "react";

function PokeballItem(props) {

    const [itemCount, setItemCount] = React.useState(0);

    function onIncrement() {
        setItemCount(itemCount + 1)
    }

    function onDecrement() {
        setItemCount(itemCount - 1)
    }

    return (
        <div style={{ display: 'flex', alignItems: 'center', flexDirection: 'column', margin: 50 }}>
            <img src={props?.data?.image} alt="Item" style={{ width: 125, height: 125 }} />
            <div style={{margin: 20, display: 'flex', alignItems: 'center'}}>
                <button style={{borderRadius: 30, width: 30, height: 30}} onClick={onDecrement}>-</button>
                <text style={{ margin: '0 10px', fontSize: 20 }}>{itemCount}</text>
                <button style={{borderRadius: 30, width: 30, height: 30}} onClick={onIncrement}>+</button>
            </div>
            <button style={{ height: 30, width: 50, borderRadius: '8px', backgroundColor: '#dc483f', color: 'white', fontSize: '12px', padding: '10px', border: 'none' }}>
                Buy
            </button>
        </div>
    );

}

export default PokeballItem;
