import React, { useEffect } from 'react';
import Text from './Text';
import Card from './Card';
import { colors } from '../theme';
import { useWeb3React } from '@web3-react/core';
import { useMiddleMan } from '../hooks/useMiddleMan';
import { useAppContext } from '../AppContext';

const BalanceCard = () => {
  const { account } = useWeb3React();
  const { fetchSenderBalance,
    fetchReceiverBalance,
    fetchContractBalance,
    contractBalance, 
    senderBalance,
    receiverBalance,
   } = useMiddleMan();

  useEffect(() => {
    if (account) {
      fetchSenderBalance();
      fetchReceiverBalance();
      fetchContractBalance();
    }
  }, [account]);

  return (
    <Card style={{ maxWidth: 300 }}>
      <Text block color={colors.green}>
        contract balance: {contractBalance}
      </Text>
      <Text block color={colors.green}>
        sender balance: {senderBalance}
      </Text>
      <Text block color={colors.green}>
        reciever balance: {receiverBalance}
      </Text>
    </Card>
  );
};

export default BalanceCard;
