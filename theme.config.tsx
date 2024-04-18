import React from 'react'
import { DocsThemeConfig, useConfig } from 'nextra-theme-docs'

const config: DocsThemeConfig = {
  logo: (
    <>
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 206 246" fill="none">
      <circle cx="40" cy="40" r="40" fill="currentColor"/>
      <circle cx="40" cy="206" r="40" fill="currentColor"/>
      <circle cx="166" cy="120" r="40" fill="currentColor"/>
    </svg>
    <span style={{ marginLeft: '.4em', fontWeight: 800 }}>
       Low Code Engineering/Software QA Guide
    </span>
  </>
  ),
  i18n: [
    { locale: 'en', text: 'English' },
    { locale: 'zh', text: '中文' },
    { locale: 'jp', text: '日本語'},
    { locale: 'pt', text: 'Português' },
    { locale: 'it', text: 'Italian' },
    { locale: 'tr', text: 'Türkçe' },
    { locale: 'es', text: 'Español' },
    { locale: 'fr', text: 'Français' },
    { locale: 'kr', text: '한국어' },
    { locale: `ca`, text: `Català` },
    { locale: 'fi', text: 'Finnish' },
    { locale: 'ru', text: 'Русский' },
    { locale: 'de', text: 'Deutsch' },
  ],

  project: {
    link: 'https://github.com/qdriven/low-code-way.git',
  },
  chat: {
    link: 'https://discord.com',
  },
  docsRepositoryBase: 'https://github.com//qdriven/low-code-way.git',
  footer: {
    text: 'Low-Code Engineer/QA Engineer Copyright © 2024',
  },
  search: {
    placeholder: 'Search...',
  },
  header: function UserHead(){
    const {title} = useConfig()
    return (<>
            <title>{title ? title + ' | Low Code Engineer/QA Engineer Guide': 'Low Code Engineer/QA Engineer Guide'} </title>
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <meta property="og:title" content="Low Code Engineer/QA Engineer Guide" />
      <meta property="og:description" content="A Comprehensive Overview of Low Code Engineer/QA Engineer Guide" />
      <meta
          name="og:title"
          content={title ? title + ' | Low Code Engineer/QA Engineer Guide' : 'Low Code Engineer/QA Engineer Guide'}
        />
      <link rel="icon" href="/144-favicon.svg" type="image/svg+xml" />

        <link
          rel="icon"
          href="/144-favicon-dark.svg"
          type="image/svg+xml"
          media="(prefers-color-scheme: dark)"
        />
    
    </>)
  }
}

export default config
