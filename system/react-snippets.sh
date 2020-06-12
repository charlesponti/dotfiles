#!/usr/bin/bash

generateReactComponent() {
  NAME=$1
  COMPONENT_PATH="src/components/$NAME/$NAME"
  
  # Make directory for component
  mkdir src/components/$NAME
  

  STYLES=""".container {
  display: flex;
}
"""

  echo $STYLES >> $COMPONENT_PATH.module.scss

  COMPONENT="""import React from 'react'
import t from 'prop-types'
import styles from './$NAME.module.scss'

export const $NAME = () => {
  return (
    <div className={styles.container}>
      
    </div>
  )
}
"""

  echo $COMPONENT >> $COMPONENT_PATH.js

  touch $COMPONENT_PATH.text.js
}
