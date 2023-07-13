import React, { useState, useEffect } from "react";

const SmsMessages = () => {
    const [messages, setMessages] = useState([]);
    const [nextPage, setNextPage] = useState(2);
    const [previousPage, setPreviousPage] = useState(0);
    const [page, setPage] = useState(0);
    const [phoneNumber, setPhoneNumber] = useState();

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
        let params = { page: nextPage };

        if (phoneNumber){
            params.phone_number = phoneNumber;
        }

        const url = "/api/messages?" + new URLSearchParams(params);
        fetch(url).then((res) => {
            if (res.ok) {
                return res.json();
            }
            throw new Error("The request was unsuccessful.");
        }).then((res) => {
            setMessages(res);
        });
        setPage(nextPage);
        setNextPage(nextPage+1)
        setPreviousPage(previousPage+1)
    }

    const getPreviousPage = () => {
        let params = { page: previousPage };

        if (phoneNumber){
            params.phone_number = phoneNumber;
        }

        const url = "/api/messages?" + new URLSearchParams(params);
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
            setPage(previousPage)
            setPreviousPage(previousPage-1)
            setNextPage(nextPage-1)
        }
    }

    const searchPhoneNumber = () => {
        const inputData = document.getElementById('phone-search-input').value

        const url = "/api/messages?" + new URLSearchParams({phone_number: inputData, page: page});
        fetch(url).then((res) => {
            if (res.ok) {
                return res.json();
            }
            throw new Error("The request was unsuccessful.");
        }).then((res) => {
            setMessages(res);
        });

        setPhoneNumber(inputData);
    }

    const smsMessages = messages.map((message, index) => (
        <tr key={index}>
            <td>{new Date(message.created_at).toLocaleDateString()}</td>
            <td>{new Date(message.created_at).toLocaleTimeString()}</td>
            <td>{message.phone_number}</td>
            <td>{message.message}</td>
            <td>{message.status}</td>
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
                    <th>Status</th>
                </tr>
                </thead>
                <tbody>
                    {smsMessages}
                </tbody>
            </table>
            <button onClick={getPreviousPage}>Previous</button>
            <button onClick={getNextPage}>Next</button>
            <br/>
            <input id="phone-search-input"></input><button onClick={searchPhoneNumber}>Search</button>
        </>
    )
}

export default SmsMessages;