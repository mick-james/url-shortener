import React from 'react'
import { Formik, Form, Field } from 'formik';

function validateUrl(value) {
  let error;
  const pattern = /^(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?$/i;
  if (!value) {
    error = 'Required';
  } else if (!pattern.test(value)) {
    error = 'Invalid url address';
  }
  return error;
}

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

const ShortenerForm = ({ shortenSuccess, shortenFail }) => (
  <Formik
    initialValues={{ url: '' }}
    // validate={values => {}}
    onSubmit={(values, { setSubmitting, setFieldError, resetForm }) => {
      setSubmitting(true);
      shortenUrl(values.url).then((response) => {
        if (response.status == 201) {
          return response.json();
        } else {
          throw new Error("An error occurred making that request");
        }
      }).then(payload => {
        shortenSuccess(values.url, payload.code);
        resetForm();
      }).catch(error => {
        shortenFail(values.url, error.message);
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
      <Form onSubmit={handleSubmit}>
        <label htmlFor="url">URL to shorten:</label>
        <Field name="url" type="text" validate={validateUrl} />
        {errors.url && touched.url && <span style={{ color: 'red' }}>{errors.url}</span>}
        <br />
        <button type="submit" disabled={isSubmitting}>
          Submit
        </button>
      </Form>
    )}
  </Formik>
)

export default ShortenerForm