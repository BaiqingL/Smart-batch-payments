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
  Button,
  Tabs,
  Tab
} from "react-bootstrap"
import './index.css';

export default class Home extends React.Component {
  render() {
    return (
    <Layout>
      <section>
        <div className="container">
          <div className="row">
            <div className="col-md-6 col-md-offset-0">
            <Tabs defaultActiveKey="profile" id="uncontrolled-tab-example">
              <Tab eventKey="home" title="BUY">
                <br></br>
                <Form>
                  <Form.Group controlId="formBasicEmail">
                    <Form.Label>I want to spend</Form.Label>
                    <Form.Control type="email" placeholder="Enter amount" />
                    <Form.Text className="text-muted">
                      Enter the amount you want
                    </Form.Text>
                  </Form.Group>

                  <Form.Group controlId="formBasicCheckbox">
                    <Form.Check type="checkbox" label="All Money" /> {/* add func to this checkbox to disable other form*/}
                  </Form.Group>
                  <Button variant="primary" type="submit"> {/* handle submit as func call to API*/}
                    Confirm
                  </Button>
                </Form>
              </Tab>
              <Tab eventKey="profile" title="SELL">
                <p>BLAH</p>
              </Tab>
              <Tab eventKey="contact" title="CONVERT">
                <p>BLAH</p>
              </Tab>
            </Tabs>
              
            </div>
          </div>
        </div>
      </section>
    </Layout>
    );
  }
}