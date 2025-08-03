package com.example.stomp.controller;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

import com.example.stomp.model.TransactionMessage;

@Controller
public class TransactionController {

    @MessageMapping("/add-transaction")
    @SendTo("/topic/transactions")
    public TransactionMessage sendTransaction(TransactionMessage transaction) {
        System.out.println("Nova transação recebida: " + transaction.getTitle());
        return transaction;
    }
}
