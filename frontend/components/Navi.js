import React, { useState } from "react";
import Link from "next/link";
import {
    Navbar,
    Brand,
    Toggle,
    Collapse,
    Nav,
    NavDropdown,
    Form,
    FormControl,
    Button
} from "react-bootstrap"

const Navi = props => {
	
	const [isOpen, setIsOpen] = useState(false);

	const toggle = () => setIsOpen(!isOpen);
	return (
		<Navbar bg="light" expand="lg">
        <Navbar.Brand href="#home">Solidity</Navbar.Brand>
        <Navbar.Toggle aria-controls="basic-navbar-nav" />
        <Navbar.Collapse id="basic-navbar-nav">
            <Nav className="mr-auto">
            <Nav.Link href="/">Home</Nav.Link>
            <Nav.Link href="/about">About</Nav.Link>
            <NavDropdown title="Currency" id="basic-nav-dropdown">
                <NavDropdown.Item href="#action/3.1">$USD</NavDropdown.Item>
                <NavDropdown.Item href="#action/3.2">$CNY</NavDropdown.Item>
                <NavDropdown.Item href="#action/3.3">$EUR</NavDropdown.Item>
                <NavDropdown.Divider />
                <NavDropdown.Item href="#action/3.4">$RMB</NavDropdown.Item>
            </NavDropdown>
            </Nav>
        <Form inline>
            <FormControl type="text" placeholder="Search" className="mr-sm-2" />
            <Button variant="outline-success">Search</Button>
        </Form>
        </Navbar.Collapse>
        </Navbar>
	);
};

export default Navi;
