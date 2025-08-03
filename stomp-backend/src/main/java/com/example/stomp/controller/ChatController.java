package com.example.stomp.controller;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

import com.example.stomp.model.ChatMessage;

@Controller
public class ChatController {

    @MessageMapping("/chat") // Cliente envia para /app/chat
    @SendTo("/topic/messages") // Servidor envia para todos no tópico
    public ChatMessage sendMessage(ChatMessage message) {
        System.out.println("Mensagem recebida: " + message.getTitle() + " - " + message.getAmount());
        return message;
    }
}
