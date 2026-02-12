// app.js
const express = require('express');
const { execFile } = require('child_process');
const app = express();
app.use(express.json());

app.get('/ffmpeg-version', (req, res) => {
  const ff = '/usr/local/bin/ffmpeg'; // caminho esperado no Dockerfile sugerido
  execFile(ff, ['-version'], (err, stdout, stderr) => {
    if (err) return res.status(500).json({ error: err.message, stderr });
    res.send(`<pre>${stdout}</pre>`);
  });
});

const port = process.env.PORT || 3000;
app.listen(port, ()=> console.log(`ffmpeg-runner listening on ${port}`));
