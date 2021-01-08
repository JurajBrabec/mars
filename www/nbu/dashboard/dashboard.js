const stateColors = [
  'rgba(0,200,200,0.5)',
  'rgba(0,200,0,0.5)',
  'rgba(200,0,0,0.5)',
  'rgba(50,50,50,0.5)',
];
const statusColors = [
  'rgba(0,250,0,0.5)',
  'rgba(250,250,0,0.5)',
  'rgba(250,0,0,0.5)',
  'rgba(240,0,0,0.5)',
  'rgba(230,0,0,0.5)',
  'rgba(220,0,0,0.5)',
  'rgba(210,0,0,0.5)',
  'rgba(200,0,0,0.5)',
  'rgba(190,0,0,0.5)',
  'rgba(180,0,0,0.5)',
  'rgba(170,0,0,0.5)',
  'rgba(160,0,0,0.5)',
  'rgba(150,0,0,0.5)',
  'rgba(140,0,0,0.5)',
  'rgba(130,0,0,0.5)',
  'rgba(120,0,0,0.5)',
  'rgba(110,0,0,0.5)',
  'rgba(100,0,0,0.5)',
  'rgba(90,0,0,0.5)',
  'rgba(80,0,0,0.5)',
  'rgba(70,0,0,0.5)',
  'rgba(60,0,0,0.5)',
  'rgba(50,0,0,0.5)',
  'rgba(30,0,0,0.5)',
  'rgba(20,0,0,0.5)',
  'rgba(10,0,0,0.5)',
  'rgba(0,0,0,0.5)',
];

const createChart = (options) => {
  const labels = [...new Set(options.data.map(options.xValue))].sort();
  const series = [...new Set(options.data.map(options.label))].sort();
  const datasets = series.map((label, index) => {
    const data = [];
    const backgroundColor = options.backgroundColor[index];
    return {
      label,
      data,
      backgroundColor,
    };
  });
  options.data.forEach((e) => {
    const x = options.xValue(e);
    const y = options.yValue(e);
    datasets[series.indexOf(options.label(e))]['data'].push({ x, y });
  });
  const container = document.getElementById(options.id);
  const div = document.createElement('div');
  div.setAttribute('class', 'chart');
  const canvas = document.createElement('canvas');
  div.append(canvas);
  container.append(div);
  const ctx = canvas.getContext('2d');
  const config = {
    type: 'line',
    data: { labels, datasets },
    options: {
      title: { display: true, text: options.title },
    },
  };
  return new Chart(ctx, config);
};

const createCharts = (options) => {
  const sourceName = (e) => `${e.masterserver}`;
  const sources = [...new Set(options.data.map(sourceName))].sort();
  sources.map((source) => {
    createChart({
      id: options.id,
      backgroundColor: stateColors,
      data: options.data.filter((e) => sourceName(e) === source),
      label: (e) => `State ${e.state}`,
      title: `${source} - started jobs`,
      xValue: (e) => e.time,
      yValue: (e) => e.started_jobs,
    });
    createChart({
      id: options.id,
      backgroundColor: statusColors,
      data: options.data.filter(
        (e) => sourceName(e) === source && e.status >= 0
      ),
      label: (e) => `${e.status}`,
      title: `${source} - ended jobs with status`,
      xValue: (e) => e.time,
      yValue: (e) => e.ended_jobs,
    });
  });
};

async function start(options) {
  try {
    await import('./Chart.bundle.min.js');
    if (options.url) {
      const response = await fetch(options.url);
      options.data = JSON.parse(await response.text());
    }
    createCharts(options);
  } catch (error) {
    console.error(error);
  }
}
const id = 'dashboard';
//import data from './history.js';
//start({ data, id});
const url = window.location.href.replace(
  'dashboard/',
  'php.php?action=get-history'
);
start({ url, id });
