import React, { useState, useEffect } from "react";

const SmsMessages = () => {
    const [messages, setMessages] = useState([]);

    useEffect(() => {
        const url = "/api/messages";
        fetch(url).then((res) =>{
            if (res.ok) {
                return res.json();
            }
            throw new Error("The request was unsuccessful.");
        }).then((res) => {
            setMessages(res);
        });
    }, []);


    const smsMessages = messages.map((message, index) => (
        <tr key={index}>
            <td>{new Date(message.created_at).toLocaleDateString()}</td>
            <td>{new Date(message.created_at).toLocaleTimeString()}</td>
            <td>{message.phone_number}</td>
            <td>{message.message}</td>
        </tr>
     ));

    return(
        <>
            <table>
                <thead>
                <tr>
                    <th>Date</th>
                    <th>Time</th>
                    <th>Phone Number</th>
                    <th>Message</th>
                </tr>
                </thead>
                <tbody>
                    {smsMessages}
                </tbody>
            </table>
        </>
    )
}

export default SmsMessages;