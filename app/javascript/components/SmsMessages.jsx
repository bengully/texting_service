import React, { useState, useEffect } from "react";

const SmsMessages = () => {
    const [messages, setMessages] = useState([]);
    const [nextPage, setNextPage] = useState(2);
    const [previousPage, setPreviousPage] = useState(0);

    useEffect(() => {
        const url = "/api/messages";
        fetch(url).then((res) => {
            if (res.ok) {
                return res.json();
            }
            throw new Error("The request was unsuccessful.");
        }).then((res) => {
            setMessages(res);
        });
    }, []);


    const getNextPage = () => {
        const url = "/api/messages?" + new URLSearchParams({page: nextPage});
        fetch(url).then((res) => {
            if (res.ok) {
                return res.json();
            }
            throw new Error("The request was unsuccessful.");
        }).then((res) => {
            setMessages(res);
        });
        setNextPage(nextPage+1)
        setPreviousPage(previousPage+1)
    }

    const getPreviousPage = () => {
        const url = "/api/messages?" + new URLSearchParams({page: previousPage});
        fetch(url).then((res) => {
            if (res.ok) {
                return res.json();
            }
            throw new Error("The request was unsuccessful.");
        }).then((res) => {
            setMessages(res);
        });
        if ((previousPage - 1 < 0)) {
            setNextPage(0)
        } else {
            setNextPage(previousPage-1)
            setNextPage(nextPage-1)
        }
    }

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
            <button onClick={getPreviousPage}>Previous</button>
            <button onClick={getNextPage}>Next</button>
        </>
    )
}

export default SmsMessages;