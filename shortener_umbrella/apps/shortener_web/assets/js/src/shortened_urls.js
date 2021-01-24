
import React, { useState } from 'react'
import ShortenerForm from "./shortener_form.js"

function truncateUrl(longUrl) {
  if (longUrl.length < 20) {
    return longUrl;
  }
  return longUrl.substr(0, 19) + '...'
}

const ShortenedUrl = ({ hostUrl, longUrl, code }) => {
  const url = hostUrl + "/" + code;
  if (!!code) {
    return <p>{truncateUrl(longUrl)}: <a href={url}>{url}</a></p>
  }
  return <span />
}

class ShortenedUrls extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      errorMessage: "",
      shortenedUrls: {}
    };
  }

  shortenSuccess(longUrl, code) {
    this.setState({ errorMessage: "", shortenedUrls: { ...this.state.shortenedUrls, [longUrl]: code } });
  }

  shortenFail(longUrl, errorString) {
    this.setState({ errorMessage: "Error shortening " + longUrl + ": " + errorString, shortenedUrls: { ...this.state.shortenedUrls } });
  }

  render() {
    const shortenedUrls = Object.keys(this.state.shortenedUrls).map(key => {
      // return (<li key={key}>{key} {this.state.shortenedUrls[key]}</li>);
      return (
        <ShortenedUrl key={key} hostUrl={this.props.url} longUrl={key} code={this.state.shortenedUrls[key]} />
      );
    });

    const shortenFunc = this.shortenSuccess.bind(this);
    const failFunc = this.shortenFail.bind(this);

    return (
      <div>
        <div className="row">
          <div className="column">
            <ShortenerForm shortenSuccess={shortenFunc} shortenFail={failFunc} />
          </div>
        </div>
        <div className="row">
          <div className="column">
            <p style={{ color: 'red' }}>{this.state.errorMessage}</p>
          </div>
        </div>
        <div className="row">
          <div className="column">
            {shortenedUrls}
          </div>
        </div>
      </div >
    );
  }
}
``
export default ShortenedUrls