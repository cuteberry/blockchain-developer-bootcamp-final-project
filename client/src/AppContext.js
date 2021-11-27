import React, { createContext, useReducer } from 'react';

const initialContext = {
  contractBalance: '--',
  setContractBalance: () => {},
  senderBalance: '--',
  setSenderBalance: () => {},
  receiverBalance: '--',
  setReceiverBalance: () => {},
  setWalletConnectModal: () => {},
  txnStatus: 'NOT_SUBMITTED',
  setTxnStatus: () => {},
};

const appReducer = (state, { type, payload }) => {
  switch (type) {
    case 'SET_CONTRACT_BALANCE':
      return {
        ...state,
        contractBalance: payload,
      };

    case 'SET_SENDER_BALANCE':
      return {
        ...state,
        senderBalance: payload,
      };

    case 'SET_RECEIVER_BALANCE':
      return {
        ...state,
        receiverBalance: payload,
      };

    case 'SET_WALLET_MODAL':
      return {
        ...state,
        isWalletConnectModalOpen: payload,
      };

    case 'SET_TXN_STATUS':
      return {
        ...state,
        txnStatus: payload,
      };
    default:
      return state;
  }
};

const AppContext = createContext(initialContext);
export const useAppContext = () => React.useContext(AppContext);
export const AppContextProvider = ({ children }) => {
  const [store, dispatch] = useReducer(appReducer, initialContext);

  const contextValue = {
    contractBalance: store.contractBalance,
    setContractBalance: (balance) => {
      dispatch({ type: 'SET_CONTRACT_BALANCE', payload: balance });
    },
    senderBalance: store.senderBalance,
    setSenderBalance: (balance) => {
      dispatch({ type: 'SET_SENDER_BALANCE', payload: balance });
    },
    receiverBalance: store.receiverBalance,
    setReceiverBalance: (rate) => {
      dispatch({ type: 'SET_RECEIVER_BALANCE', payload: rate });
    },
    isWalletConnectModalOpen: store.isWalletConnectModalOpen,
    setWalletConnectModal: (open) => {
      dispatch({ type: 'SET_WALLET_MODAL', payload: open });
    },
    txnStatus: store.txnStatus,
    setTxnStatus: (status) => {
      dispatch({ type: 'SET_TXN_STATUS', payload: status });
    },
  };

  return <AppContext.Provider value={contextValue}>{children}</AppContext.Provider>;
};
