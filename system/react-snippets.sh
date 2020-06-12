#!/usr/bin/bash

generateReactComponent() {

NAME=$1
COMPONENT_PATH="src/components/$NAME/$NAME"

# Make directory for component
mkdir src/components/$NAME
  
# Create stylesheet
echo """.container {
  display: flex;
}
""" >> $COMPONENT_PATH.module.scss

# Create component
echo """import React from 'react'
import t from 'prop-types'
import styles from './$NAME.module.scss'

function $NAME() {
  return (
    <div className={styles.container}>
      
    </div>
  )
}

export default $NAME
""" >> src/components/$NAME/index.js

# Create test file
echo """
import React from 'react'
import { render } from '@testing-library/react'
import $NAME from './$NAME'

describe('<$NAME/>', () => {
  it('should render component', () => {
    const { container } = render(<$NAME/>)
    expect(container).toMatchSnapshot()
  })
})
""" >> $COMPONENT_PATH.test.js
}
