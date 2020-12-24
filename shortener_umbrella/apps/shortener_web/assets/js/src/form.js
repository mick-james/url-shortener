import React from 'react'
import { Formik } from 'formik';

function shortenUrl(url) {
  const location = window.location.hostname;
  const settings = {
    method: 'POST',
    headers: {
      Accept: 'application/json',
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ "url": url })
  };
  return fetch(`/api/shorten`, settings);
}

const ShortenedUrl = ({ url, code }) => {
  if (!!code) {
    return <p>Your short url: {url}/{code}</p>
  }
  return <span />
}

const ShortenerForm = ({ url }) => (
  <div className="column">
    <Formik
      initialValues={{ url: '' }}
      // validate={values => {}}
      onSubmit={(values, { setSubmitting, setFieldError, setFieldValue }) => {
        setSubmitting(true);
        shortenUrl(values.url).then((response) => {
          if (response.status == 201) {
            return response.json();
          } else {
            setFieldError("general", "An error occurred making that request");
          }
        }).then(payload => {
          setFieldValue("code", payload.code);
        }).catch(error => {
          setFieldError("general", error.message);
        }).finally(() => {
          setSubmitting(false);
        });
      }}>
      {({
        values,
        errors,
        touched,
        handleChange,
        handleBlur,
        handleSubmit,
        isSubmitting
      }) => (
        <form onSubmit={handleSubmit}>
          <label htmlFor="url">URL to shorten:</label>
          <input
            type="text"
            name="url"
            onChange={handleChange}
            onBlur={handleBlur}
            value={values.url}
            required
          />
          {errors.url && touched.url && errors.url}
          <br />
          <button type="submit" disabled={isSubmitting}>
            Submit
          </button>
          <p style={{ color: 'red' }}>{errors.general}</p>
          <ShortenedUrl url={url} code={values.code} />
        </form>
      )}
    </Formik>
  </div>
)

export default ShortenerForm