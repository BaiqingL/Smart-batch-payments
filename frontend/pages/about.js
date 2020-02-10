import React, { useState } from 'react';
import Layout from "../components/layout";
import Link from "next/link";
import {
  Navbar,
  Brand,
  Toggle,
  Collapse,
  NavDropdown,
  Form,
  FormControl,
  Button
} from "react-bootstrap"
import './index.css';

export default class Home extends React.Component {
  render() {
    return (
    <Layout>
      <section className="text-center">
        <div className="container">
            <h1>What does Solidity do?</h1>
            <h5>Summary</h5>
        </div>
      </section>
    </Layout>
    );
  }
}