import React from 'react'
import { GetStaticProps, NextPage } from 'next'

import { LoggerProvider } from '@scaling/logger'

import { Login, Initializers } from '@scaling-applications/passport'
import { InitializerData } from '@scaling/application-initializers'
import { GuestLayout } from '@ui/layouts'

interface IndexPageInitialProps {
  data: InitializerData
}

interface IndexPageProps extends IndexPageInitialProps {}

const IndexPage: NextPage<IndexPageProps, IndexPageInitialProps> = ({
  data,
}) => {
  return (
    <Initializers data={data}>
      <LoggerProvider>
        <GuestLayout>
          <Login />
        </GuestLayout>
      </LoggerProvider>
    </Initializers>
  )
}

export const getStaticProps: GetStaticProps = async context => {
  const data = await Initializers.getInitializerProps(context)

  return {
    props: {
      data,
    },
  }
}

export default IndexPage
