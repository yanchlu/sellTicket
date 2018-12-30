pragma solidity ^0.4.0;
contract sellTicket{
    string hello;
    struct Ticket{
        uint tid;
        uint price;
        uint amount;
    }
    struct Customer{
        uint cid;
        uint wallet;
        uint[] own;
    }
    
    address seller;
    mapping(address => Customer)  customers;
    Ticket[] public TicketSet;
    
     uint flag = 0;
     //init
    function sellTicket() public {
        seller = msg.sender;
    }
    
    function showflag()constant public returns (uint) {
        return flag;
    }
    //seller's function
    function publishTicket(uint id,uint p,uint c,address sender) public {
        flag = 1;
        uint len = TicketSet.length;
        for(uint i = 0;i < len;i++){
            if(TicketSet[i].tid == id)
            return;
        }
        flag = 2;
        if (sender != seller) return;
        TicketSet.length = len + 1;
        Ticket memory newTicket;
        newTicket.tid = id;
        newTicket.price = p;
        newTicket.amount = c;
        TicketSet[len] = newTicket;
        flag = 3;
    }
    function Recharge(address c,uint money) public {
        if (msg.sender != seller) return;
        customers[c].wallet = customers[c].wallet + money;
    }
    
    //customers' function
    function showWallet(address c) public returns(uint){
        return customers[c].wallet;
    }
    
    function buyTicket(uint tid,uint num,address sender) public {
        flag = 1;
        uint p = 0;
        uint k;
        uint len = TicketSet.length;
        for(uint i = 0;i < len;i++){
            if(TicketSet[i].tid == tid){
                flag = 2;
                p = TicketSet[i].price;
                k = TicketSet[i].amount;
                break;
            }
        }
        if(flag == 1) return;
        Customer memory buyer = customers[sender]; // assigns reference
        p = p * num;
        flag = 2;
        if (p > buyer.wallet) return;
        flag = 3;
        if  (k < num) return;
        buyer.wallet = buyer.wallet - p;
        TicketSet[k].amount = TicketSet[k].amount - num;
        buyer.own[tid] = buyer.own[tid] + num;
        flag = 4;
    }
    
    function refundTicket(uint tid,uint num,address sender) public {
        flag = 1;
        uint p;
        uint k;
        uint len = TicketSet.length;
        for(uint i = 0;i < len;i++){
            if(TicketSet[i].tid == tid){
                flag = 2;
                p = TicketSet[i].price;
                k = TicketSet[i].amount;
                break;
            }
        }
        flag = 2;
        Customer storage buyer = customers[sender]; 
        if(num > buyer.own[tid]) return;
        p = p * num;
        buyer.wallet = buyer.wallet + p;
        buyer.own[tid] = buyer.own[tid] - num;
        flag = 3;
    }
    

    //Both
    function getaddress()constant public returns(address){
        return msg.sender;
    }

    function showTicketPrice(uint id)constant public returns (uint) {
        return TicketSet[id].price;
    }
    function showTicketAmount(uint id)constant public returns (uint) {
        return TicketSet[id].amount;
    }
}