import React from 'react';
import { createRoot } from 'react-dom/client';

export const HomeIndex = () => {

  return (
    <>
      <h2>Hello from React</h2>
    </>
  );
};

const container = document.getElementById('homeIndex');
const root = createRoot(container);
root.render(<HomeIndex />);