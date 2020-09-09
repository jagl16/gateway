import React, { FunctionComponent } from 'react'
import PropTypes from 'prop-types';

export const HelloWorld: FunctionComponent<{ message?: string }> = ({ message = "Hello World!" }) => {
    return <p>{ message }</p>
}

HelloWorld.propTypes = {
    message: PropTypes.string
}
