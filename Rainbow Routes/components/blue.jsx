import React from 'react';
import { Route, Link, NavLink } from 'react-router-dom';
import Indigo from './indigo';


class Blue extends React.Component {
  render() {
    return (
      <div>
        <h2 className="blue"></h2>
        <Navlink exact to="blue"> Blue only</Navlink>
        <NavLink to="/blue/indigo"> Add indigo</NavLink>

        {/* Routes here */}
        <Route path="/blue/indigo" componsent={Indigo} />
      </div>
    );
  }
};

export default Blue;
