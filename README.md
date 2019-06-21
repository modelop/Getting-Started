<!DOCTYPE html>
<html lang="en-US">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <link rel="stylesheet" href="https://github.com/merhi-odg/elmo-example/blob/master/style.css">
</head>
<body>
    <div class="pagecontent">
<br>
<h1 id="Conform-and-deploy-elmo-example">Conform and Deploy a Model: an ELMo Example</h1>
<p>This is a step by step guide for conforming and deploying a model in FastScore. 
It contains instructions for data scientists to prepare, deploy and test their model. 
This guide was last updated for v1.10 of FastScore.</p>

<p>As we go, we will be referring to an example ELMo/XGBoost model available in the 
<code class="highlighter-rouge">elmo-example</code> branch of 
<a href="https://github.com/opendatagroup/Getting-Started/tree/examples">this repo</a>.</p>

<h1 id="contents">Contents</h1>

<ol>
  <li><a href="#Prerequisites">Pre-requisites</a></li>
  <li><a href="#model-deployment-package">Defining Deployment Package Overview</a>
    <ol>
      <li><a href="#model-dependencies">Model Dependencies</a></li>
      <li><a href="#model-schema">Model Schema</a></li>
      <li><a href="#model-execution-script">Model Execution Script</a></li>
      <li><a href="#attachments">Attachments</a></li>
      <li><a href="#streams">Streams</a></li>
    </ol>
  </li>
  <li><a href="#Deploy-as-REST">Deploy as REST</a></li>
  <li><a href="#Test-Model">Test Model</a></li>

</ol>

<h2 id="pre-requisites"><a name="Prerequisites"></a>Pre-requisites</h2>
<p>Before we walk through how to conform and deploy a model, we will need the following pre-requisites:</p>

<ol>
  <li><a href="https://opendatagroup.github.io/Getting%20Started/Getting%20Started%20with%20FastScore/">
      FastScore Environment Installed</a></li>
  <li><a href="https://opendatagroup.github.io/Getting%20Started/Getting%20Started%20with%20FastScore/#installing-the-fastscore-cli">
      FastScore CLI Installed</a></li>
  <li><a href="https://github.com/opendatagroup/Getting-Started/tree/elmo-example">
      Example repo downloaded</a></li>
</ol>

<p>To download the repo:</p>

<div class="language-bash highlighter-rouge">
    <div class="highlight">
        <pre class="highlight">
<code>git clone https://github.com/opendatagroup/Getting-Started.git
<span class="nb">cd </span>Getting-Started
git checkout elmo-example</code>
</pre></div></div>

<p>To setup the environment:</p>

<div class="language-bash highlighter-rouge">
    <div class="highlight">
        <pre class="highlight">
<code>docker build -t localrepo/engine:elmo-example .
make deploy</code>
</pre></div></div>

<p>To verify successful setup, run</p>
<div class="language-bash highlighter-rouge">
    <div class="highlight">
        <pre class="highlight">
<code>fastscore fleet --wait</code>
</pre></div></div>

<p>You should expect the following output:</p>

<div class="language-bash highlighter-rouge">
    <div class="highlight">
        <pre class="highlight">
<code>       NAME      |     API      |     HOST     | HEALTH
-----------------+--------------+--------------+---------
  engine-2       | engine       | engine-2     | <span style="color: #2ECC71;">ok</span>
  engine-1       | engine       | engine-1     | <span style="color: #2ECC71;">ok</span>
  model-manage-1 | model-manage | model-manage | <span style="color: #2ECC71;">ok</span></code>
</pre></div></div>


<h2 id="defining-model-deployment-package"><a name="model-deployment-package"></a>Defining Model Deployment Package</h2>
<p>FastScore provides several key assets for deploying and managing a model throughout the Model Lifecycle. 
As Data Scientists, we define these abstractions for a robust deployment of our model that can evolve during 
the productionalization process without intensive input from the Data Scientist downstream.</p>

<table>
  <thead>
    <tr>
      <th>Asset</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>1. Model Dependencies</td>
      <td>Definition of the Runtime environment of the model with necessary dependencies for execution.</td>
    </tr>
    <tr>
      <td>2. Schemas</td>
      <td>The definition of a Model’s type signature for inputs and outputs defined in Avro.</td>
    </tr>
    <tr>
      <td>3. Model Execution Script</td>
      <td>Model execution or prediction script that read input data from source, predicts, and writes output.</td>
    </tr>
    <tr>
      <td>4. Attachments</td>
      <td>Binary objects, serialized model coefficients, or other artifacts from training that are required for model execution. 
      FastScore pulls these attachments into a working directory upon deployment.</td>
    </tr>
    <tr>
      <td>5. Streams</td>
      <td>Definition of the data input/output that a model reads/writes from/to while executing.</td>
    </tr>
  </tbody>
</table>

<h3 id="1-model-dependencies"><a name="model-dependencies"></a>1. Model Dependencies</h3>
<p>FastScore Engine manages the deployment and running of the model within a Docker container. 
As part of the deployment process, we will need to build the dependencies for our model on top of the base FastScore Engine container. 
This is a key piece for the Data Scientist to hand off to the Model Operations team to ensure the model can run downstream.</p>

<p>For our example, we will need to build in the dependencies into the FastScore Engine. 
The <code class="highlighter-rouge">elmo-example</code> branch’s docker-compose file points to the pre-built image on Dockerhub, 
but here are the steps to manually add them for your model. The image is defined using the Dockerfile. 
To build the image in the local repo, we run <code class="highlighter-rouge">docker build -t localrepo/engine:elmo-example .</code> 
within the directory. Then, docker-compose.yaml points "engine-1" to utilize the new Engine. 
We finally deploy with <code class="highlighter-rouge">make</code> or <code class="highlighter-rouge">make deploy</code>.</p>

<p>Here are the key components that define the image:</p>

<p>Dockerfile</p>
<!-- HTML generated using hilite.me -->
<div style="background: #f8f8f8; overflow:auto;width:auto;border:solid gray;border-width:.1em .1em .1em .8em;padding:.2em .6em;">
    <pre style="margin: 0; line-height: 125%">
<span style="color: #BA2121">FROM</span> fastscore/engine:ubuntu
<span style="color: #BA2121">WORKDIR</span> /fastscore

<span style="color: #BA2121">RUN</span> pip3 install --upgrade pip
<span style="color: #BA2121">RUN</span> pip3 install --upgrade setuptools
<span style="color: #BA2121">RUN</span> pip3 install --upgrade tensorflow
<span style="color: #BA2121">RUN</span> pip3 install --upgrade tensorflow_hub
<span style="color: #BA2121">RUN</span> pip3 install --upgrade xgboost

<span style="color: #BA2121">USER</span> root
<span style="color: #BA2121">RUN</span> echo <span style="color: #0000FF">&quot;tensorflow&quot;</span>     &gt;&gt; /fastscore/lib/&#96;ls /fastscore/lib | grep engine&#96;/priv/runners/python3/python.stdlib
<span style="color: #BA2121">RUN</span> echo <span style="color: #0000FF">&quot;tensorflow_hub&quot;</span> &gt;&gt; /fastscore/lib/`ls /fastscore/lib | grep engine`/priv/runners/python3/python.stdlib
<span style="color: #BA2121">RUN</span> echo <span style="color: #0000FF">&quot;xgboost&quot;</span>        &gt;&gt; /fastscore/lib/`ls /fastscore/lib | grep engine`/priv/runners/python3/python.stdlib
</pre></div>
<br>

<p>docker-compose.yaml</p><!-- HTML generated using http://highlight.hohli.com -->
<div style="background: #f8f8f8; overflow:auto;width:auto;border:solid gray;border-width:.1em .1em .1em .8em;padding:.2em .6em;">
<pre class="yaml" style="font-family:monospace;"><span style="color: green;">version</span><span style="font-weight: bold; color: brown;">: </span>'3'<span style="color: #007F45;">
services</span><span style="font-weight: bold; color: brown;">:
</span><span style="color: #007F45;">
  engine-1</span>:<span style="color: green;">
    image</span><span style="font-weight: bold; color: brown;">: </span>localrepo/engine:elmo-example<span style="color: green;">
    stdin_open</span><span style="font-weight: bold; color: brown;">: </span>true<span style="color: green;">
    tty</span><span style="font-weight: bold; color: brown;">: </span>true<span style="color: #007F45;">
    environment</span>:<span style="color: green;">
        CONNECT_PREFIX</span><span style="font-weight: bold; color: brown;">: </span>https://connect:8001<span style="color: #007F45;">
    networks</span><span style="font-weight: bold; color: brown;">:
</span>      - fsnet<span style="color: #007F45;">
    labels</span>:<span style="color: green;">
      com.opendatagroup.fastscore.service</span><span style="font-weight: bold; color: brown;">: </span>engine<span style="color: #007F45;">
    volumes</span><span style="font-weight: bold; color: brown;">:
</span>      - ./data:/data
<span style="color: #007F45;">
  engine-2</span>:<span style="color: green;">
    image</span><span style="font-weight: bold; color: brown;">: </span>localrepo/engine:elmo-example<span style="color: green;">
    stdin_open</span><span style="font-weight: bold; color: brown;">: </span>true<span style="color: green;">
    tty</span><span style="font-weight: bold; color: brown;">: </span>true<span style="color: #007F45;">
    environment</span>:<span style="color: green;">
        CONNECT_PREFIX</span><span style="font-weight: bold; color: brown;">: </span>https://connect:8001<span style="color: #007F45;">
    networks</span><span style="font-weight: bold; color: brown;">:
</span>      - fsnet<span style="color: #007F45;">
    labels</span>:<span style="color: green;">
      com.opendatagroup.fastscore.service</span><span style="font-weight: bold; color: brown;">: </span>engine<span style="color: #007F45;">
    volumes</span><span style="font-weight: bold; color: brown;">:
</span>      - ./data:/data
<span style="color: #007F45;">
  proxy</span>:<span style="color: green;">
    image</span><span style="font-weight: bold; color: brown;">: </span>fastscore/dashboard:1.10<span style="color: #007F45;">
    ports</span><span style="font-weight: bold; color: brown;">:
</span>        - <span style="color: #CF00CF;">&quot;8000:8000&quot;</span><span style="color: green;">
    stdin_open</span><span style="font-weight: bold; color: brown;">: </span>true<span style="color: green;">
    tty</span><span style="font-weight: bold; color: brown;">: </span>true<span style="color: #007F45;">
    environment</span>:<span style="color: green;">
      CONNECT_PREFIX</span><span style="font-weight: bold; color: brown;">: </span>https://connect:8001<span style="color: #007F45;">
    networks</span><span style="font-weight: bold; color: brown;">:
</span>      - fsnet<span style="color: #007F45;">
    labels</span>:<span style="color: green;">
        com.opendatagroup.fastscore.service</span><span style="font-weight: bold; color: brown;">: </span>proxy
<span style="color: #007F45;">
  connect</span>:<span style="color: green;">
    image</span><span style="font-weight: bold; color: brown;">: </span>fastscore/connect:1.10<span style="color: #007F45;">
    ports</span><span style="font-weight: bold; color: brown;">:
</span>        - <span style="color: #CF00CF;">&quot;8001:8001&quot;</span><span style="color: green;">
    stdin_open</span><span style="font-weight: bold; color: brown;">: </span>true<span style="color: green;">
    tty</span><span style="font-weight: bold; color: brown;">: </span>true<span style="color: #007F45;">
    networks</span><span style="font-weight: bold; color: brown;">:
</span>      - fsnet
<span style="color: #007F45;">
  mm-mysql</span>:<span style="color: green;">
    image</span><span style="font-weight: bold; color: brown;">: </span>fastscore/model-manage-mysql:1.10<span style="color: #007F45;">
    volumes</span><span style="font-weight: bold; color: brown;">:
</span>      - db-data:/var/lib/mysql<span style="color: #007F45;">
    networks</span><span style="font-weight: bold; color: brown;">:
</span>      - fsnet
<span style="color: #007F45;">
  model-manage</span>:<span style="color: green;">
    image</span><span style="font-weight: bold; color: brown;">: </span>fastscore/model-manage:1.10<span style="color: #007F45;">
    environment</span>:<span style="color: green;">
      CONNECT_PREFIX</span><span style="font-weight: bold; color: brown;">: </span>https://connect:8001<span style="color: #007F45;">
    networks</span><span style="font-weight: bold; color: brown;">:
</span>      - fsnet
<span style="color: #007F45;">
  kafka</span>:<span style="color: green;">
    image</span><span style="font-weight: bold; color: brown;">: </span>fastscore/kafka<span style="color: #007F45;">
    ports</span><span style="font-weight: bold; color: brown;">:
</span>      - <span style="color: #CF00CF;">&quot;9092:9092&quot;</span><span style="color: #007F45;">
    networks</span><span style="font-weight: bold; color: brown;">:
</span>      - fsnet
<span style="color: #007F45;">
volumes</span>:<span style="color: #007F45;">
  db-data</span><span style="font-weight: bold; color: brown;">:
</span><span style="color: #007F45;">
networks</span><span style="font-weight: bold; color: brown;">:
</span>  fsnet:</pre></div><br>

<h3 id="2-defining-model-schema"><a name="model-schema"></a>2. Defining Model Schema</h3>
<p>Next, we will define the Schemas for our input and output data. Schemata specify a “language-neutral type signature” for a model. 
We use these to define the handoff between the model and the data pipeline. Input/output data will be validated against the schema 
and rejected if it does not match, giving us visibility of issues between the model and the data pipeline. 
FastScore uses <a href="http://avro.apache.org/docs/current/">Apache Avro</a> and they are defined in JSON files that are added 
to Model Manage.</p>

<p>With the FastScore CLI, we can infer the schema from a sample data record using the following command:</p>

<p><code class="highlighter-rouge">fastscore schema infer &lt;data-file&gt;</code><br>
<code class="highlighter-rouge">fastscore schema infer data/input_data.json --json</code></p>

<p>This will return the following, which we save as <code class="highlighter-rouge">library/schemas/three-strings.avsc</code>:</p>
<!-- HTML generated using hilite.me -->
<div style="background: #f8f8f8; overflow:auto;width:auto;border:solid gray;border-width:.1em .1em .1em .8em;padding:.2em .6em;">
    <pre style="margin: 0; line-height: 125%">{
    <span style="color: #008000; font-weight: bold">&quot;items&quot;</span>: {
        <span style="color: #008000; font-weight: bold">&quot;fields&quot;</span>: [
            {
                <span style="color: #008000; font-weight: bold">&quot;name&quot;</span>: <span style="color: #BA2121">&quot;label&quot;</span>,
                <span style="color: #008000; font-weight: bold">&quot;type&quot;</span>: <span style="color: #BA2121">&quot;string&quot;</span>
            },
            {
                <span style="color: #008000; font-weight: bold">&quot;name&quot;</span>: <span style="color: #BA2121">&quot;comment_text&quot;</span>,
                <span style="color: #008000; font-weight: bold">&quot;type&quot;</span>: <span style="color: #BA2121">&quot;string&quot;</span>
            },
            {
                <span style="color: #008000; font-weight: bold">&quot;name&quot;</span>: <span style="color: #BA2121">&quot;id&quot;</span>,
                <span style="color: #008000; font-weight: bold">&quot;type&quot;</span>: <span style="color: #BA2121">&quot;string&quot;</span>
            }
        ],
        <span style="color: #008000; font-weight: bold">&quot;name&quot;</span>: <span style="color: #BA2121">&quot;recab2a72d7&quot;</span>,
        <span style="color: #008000; font-weight: bold">&quot;type&quot;</span>: <span style="color: #BA2121">&quot;record&quot;</span>
    },
    <span style="color: #008000; font-weight: bold">&quot;type&quot;</span>: <span style="color: #BA2121">&quot;array&quot;</span>
}
</pre></div>
<br>

<p>For the output schema, our model will output each prediction as a probability:</p>
<!-- HTML generated using hilite.me -->
<div style="background: #f8f8f8; overflow:auto;width:auto;border:solid gray;border-width:.1em .1em .1em .8em;padding:.2em .6em;">
    <pre style="margin: 0; line-height: 125%">{<span style="color: #008000; font-weight: bold">&quot;type&quot;</span>:<span style="color: #BA2121">&quot;double&quot;</span>}
</pre></div>
<br>

<p>We will save that one as <code class="highlighter-rouge">library/schemas/double.avsc</code>.</p>

<p>And now we will add our schemas to Model Manage using the following commands:</p>

<p><code class="highlighter-rouge">fastscore schema add three_strings library/schemas/three-strings.avsc</code><br>
<code class="highlighter-rouge">fastscore schema add double library/schemas/double.avsc</code></p>

<p>To test these schemas, we can verify them against the input data:</p>

<p><code class="highlighter-rouge">fastscore schema verify --verbose three_strings data/input_data.json</code></p>

<h3 id="3-model-execution-script"><a name="model-execution-script"></a>3. Model Execution Script</h3>
<p>Next, we’re going to define the Model Execution Script, which will determine how the model predicts our output from the input data. 
This will be the key piece that pulls together and calls the other portions of our deployment package.</p>

<p>We’ll need to define several pieces of the model execution script:</p>
<ol>
  <li>Model Annotation - Control flags to define model scoring behavior including which schemas are tied to which slots.</li>
  <li>Import Dependencies - Defined in Dockerfile and imported to make them available in the Engine</li>
  <li>Trained Model Artifact from Attachment - Loaded and made available for reference at the beginning of the script.</li>
  <li>Prediction Code - Activated when input data is received and writes to output.</li>
</ol>

<p>Tip: it’s best practice to build a ‘shell’ or echo version of your model to validate the input and output data flow 
prior to adding in the prediction portions. This will allow us to validate and test the schemata and data flow of the model 
prior to introducing additional complexity of prediction.</p>

<p>The prediction code is a snippet (Python3, in this case) that scores incoming data using a trained model. 
Data coming in will be received from the input Stream to Slot(0). 
A prediction can then be generated by a trained model which has been serialized as a binary file; in this example the trained model is 
loaded as a pickle file <code class="highlighter-rouge">ELMo_nlp_xgboost.pickle</code>. The predictions are then written to the output slot, Slot(1), 
and the Stream attached there.</p>

<p>FastScore includes both a Python2 and Python3 model runners. By default, <code class="highlighter-rouge">.py</code> 
files are interpreted as Python2 models; to load a Python3 model, use the file extension <code class="highlighter-rouge">.py3</code>, or the flag <code class="highlighter-rouge">-type:python3</code> option with <code class="highlighter-rouge">fastscore model add</code>:</p>

<div class="language-bash highlighter-rouge"><div class="highlight"><pre class="highlight"><code>fastscore model add <span class="nt">-type</span>:python3 my_py3_model path/to/model.py
</code></pre></div></div>

<p>ELMo_nlp.py3</p>
<!-- HTML generated using hilite.me -->
<div style="background: #f8f8f8; overflow:auto;width:auto;border:solid gray;border-width:.1em .1em .1em .8em;padding:.2em .6em;">
    <pre style="margin: 0; line-height: 125%">
<span style="color: #408080; font-style: italic">#fastscore.action: unused</span>
<span style="color: #408080; font-style: italic">#fastscore.schema.0: three_strings</span>
<span style="color: #408080; font-style: italic">#fastscore.schema.1: double</span>
<span style="color: #408080; font-style: italic">#fastscore.recordsets.1: true</span>
<span style="color: #408080; font-style: italic">#fastscore.module-attached: tensorflow</span>
<span style="color: #408080; font-style: italic">#fastscore.module-attached: tensorflow_hub</span>
<span style="color: #408080; font-style: italic">#fastscore.module-attached: xgboost</span>

<span style="color: #008000; font-weight: bold">from</span> <span style="color: #0000FF; font-weight: bold">fastscore.io</span> <span style="color: #008000; font-weight: bold">import</span> Slot

<span style="color: #008000; font-weight: bold">import</span> <span style="color: #0000FF; font-weight: bold">xgboost</span> <span style="color: #008000; font-weight: bold">as</span> <span style="color: #0000FF; font-weight: bold">xgb</span>
<span style="color: #008000; font-weight: bold">import</span> <span style="color: #0000FF; font-weight: bold">pickle</span>
<span style="color: #008000; font-weight: bold">import</span> <span style="color: #0000FF; font-weight: bold">tensorflow_hub</span> <span style="color: #008000; font-weight: bold">as</span> <span style="color: #0000FF; font-weight: bold">hub</span>
<span style="color: #008000; font-weight: bold">import</span> <span style="color: #0000FF; font-weight: bold">tensorflow</span> <span style="color: #008000; font-weight: bold">as</span> <span style="color: #0000FF; font-weight: bold">tf</span>
<span style="color: #008000; font-weight: bold">import</span> <span style="color: #0000FF; font-weight: bold">numpy</span> <span style="color: #008000; font-weight: bold">as</span> <span style="color: #0000FF; font-weight: bold">np</span>
<span style="color: #008000; font-weight: bold">import</span> <span style="color: #0000FF; font-weight: bold">pandas</span> <span style="color: #008000; font-weight: bold">as</span> <span style="color: #0000FF; font-weight: bold">pd</span>
<span style="color: #008000; font-weight: bold">from</span> <span style="color: #0000FF; font-weight: bold">math</span> <span style="color: #008000; font-weight: bold">import</span> floor

slot0 <span style="color: #666666">=</span> Slot(<span style="color: #666666">0</span>)
slot1 <span style="color: #666666">=</span> Slot(<span style="color: #666666">1</span>)

input_data <span style="color: #666666">=</span> slot0<span style="color: #666666">.</span>read(format<span style="color: #666666">=</span><span style="color: #BA2121">&quot;pandas.standard&quot;</span>)
input_data <span style="color: #666666">=</span> input_data<span style="color: #666666">.</span>iloc[<span style="color: #666666">1</span>:]

elmo <span style="color: #666666">=</span> hub<span style="color: #666666">.</span>Module(<span style="color: #BA2121">&quot;https://tfhub.dev/google/elmo/2&quot;</span>, trainable<span style="color: #666666">=</span><span style="color: #008000">False</span>)

<span style="color: #008000; font-weight: bold">def</span> <span style="color: #0000FF">elmo_vectors</span>(x):
    embeddings <span style="color: #666666">=</span> elmo(x<span style="color: #666666">.</span>tolist(), signature<span style="color: #666666">=</span><span style="color: #BA2121">&quot;default&quot;</span>, as_dict<span style="color: #666666">=</span><span style="color: #008000">True</span>)[<span style="color: #BA2121">&quot;elmo&quot;</span>]
    <span style="color: #008000; font-weight: bold">with</span> tf<span style="color: #666666">.</span>Session() <span style="color: #008000; font-weight: bold">as</span> sess:
        sess<span style="color: #666666">.</span>run(tf<span style="color: #666666">.</span>global_variables_initializer())
        sess<span style="color: #666666">.</span>run(tf<span style="color: #666666">.</span>tables_initializer())
        <span style="color: #408080; font-style: italic"># return average of ELMo features</span>
        <span style="color: #008000; font-weight: bold">return</span> sess<span style="color: #666666">.</span>run(tf<span style="color: #666666">.</span>reduce_mean(embeddings,<span style="color: #666666">1</span>))

percent_samples <span style="color: #666666">=</span> <span style="color: #666666">1</span> <span style="color: #408080; font-style: italic"># set to 1 to score all of input dataset       </span>

batch_size <span style="color: #666666">=</span> <span style="color: #666666">50</span>
    
list_input_data <span style="color: #666666">=</span> [input_data[i:i<span style="color: #666666">+</span>batch_size] <span style="color: #008000; font-weight: bold">for</span> i <span style="color: #AA22FF; font-weight: bold">in</span> <span style="color: #008000">range</span>(<span style="color: #666666">0</span>,floor(percent_samples<span style="color: #666666">*</span>input_data<span style="color: #666666">.</span>shape[<span style="color: #666666">0</span>]),batch_size)]

<span style="color: #408080; font-style: italic"># Extract ELMo embeddings</span>
elmo_vecs <span style="color: #666666">=</span> [elmo_vectors(x[<span style="color: #BA2121">&#39;comment_text&#39;</span>]) <span style="color: #008000; font-weight: bold">for</span> x <span style="color: #AA22FF; font-weight: bold">in</span> list_input_data]

elmo_vecs <span style="color: #666666">=</span> np<span style="color: #666666">.</span>concatenate(elmo_vecs, axis <span style="color: #666666">=</span> <span style="color: #666666">0</span>)

loaded_model <span style="color: #666666">=</span> pickle<span style="color: #666666">.</span>load(<span style="color: #008000">open</span>(<span style="color: #BA2121">&quot;ELMo_nlp_xgboost.pickle&quot;</span>,<span style="color: #BA2121">&quot;rb&quot;</span>))

predictions <span style="color: #666666">=</span> loaded_model<span style="color: #666666">.</span>predict(xgb<span style="color: #666666">.</span>DMatrix(elmo_vecs))

out <span style="color: #666666">=</span> pd<span style="color: #666666">.</span>Series(predictions)

slot1<span style="color: #666666">.</span>write(out)
</pre></div> 
<br>

<p>Here are the options for model annotations in FastScore to control the behavior of the model in FastScore:</p>

<table>
  <thead>
    <tr>
      <th>Annotation</th>
      <th>Format</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Schema Assignment</td>
      <td><code class="highlighter-rouge"># fastscore.schema.&lt;slot #&gt;: &lt;schema-name&gt;</code></td>
      <td>Ties schema to a slot to verify data for that slot</td>
    </tr>
    <tr>
      <td>Recordsets</td>
      <td><code class="highlighter-rouge"># fastscore.recordsets.:&lt;slot #&gt;: &lt;true/false&gt;</code></td>
      <td>Enables recordsets for that slot</td>
    </tr>
    <tr>
      <td>Action Unused</td>
      <td><code class="highlighter-rouge"># fastscore.action: unused</code></td>
      <td>Defines conformance approach</td>
    </tr>
    <tr>
      <td>Module Attached</td>
      <td><code class="highlighter-rouge"># fastscore.module-attached:&lt;module-name&gt;</code></td>
      <td>Disables the import policy checking for imported module</td>
    </tr>
    <tr>
      <td>Disable Schema Checking</td>
      <td><code class="highlighter-rouge"># fastscore.schema.:&lt;slot #&gt;: in-use</code></td>
      <td>Used during testing to disable schema checking</td>
    </tr>
  </tbody>
</table>

<p>For our example, the first annotation designates we will not be using the ‘call-back’-style conformance. 
Note: this model and guide focus on a new form of conformance that is released in Version 1.10. 
There is also the ability to use the ‘call-back conformance’ which utilizes <code class="highlighter-rouge">begin</code> 
and <code class="highlighter-rouge">action</code> functions instead of the <code class="highlighter-rouge">slot</code> 
object as shown in <a href="https://opendatagroup.github.io/Knowledge%20Center/Tutorials/Gradient%20Boosting%20Regressor/">
this example</a>. Both will run within the latest versions of the FastScore Engine.</p>

<p>Once we’ve defined this, we need to add the model execution script to FastScore with the following command:</p>
<p><code class="highlighter-rouge">fastscore model add &lt;model-name&gt; &lt;source-file&gt;</code><br>
<code class="highlighter-rouge">fastscore model add ELMo_nlp-py3 library/models/ELMo_nlp.py3</code></p>

<h3 id="4-attachments"><a name="attachments"></a>4. Attachments</h3>
<p>Attachments consist of external files to be utilized during prediction or scoring. 
The contents of the attachment get extracted into the current working directory of the model execution script.  
Attachments will be tracked in Model Manage and Git if we’re using the integration, so they are recommended to be less than 20MB. 
Larger artifacts can be added to the Engine via the Dockerfile.</p>

<p>In our example, we reference <code class="highlighter-rouge">ELMo_nlp_xgboost.pickle</code> 
which is our trained model that we will use for predictions. FastScore will unpack the file in the working directory 
so the model can utilize it. To add it to FastScore, we upload it the model and add it to Model Manage 
with the following CLI command:</p>

<p><code class="highlighter-rouge">fastscore attachment upload &lt;model-name&gt; &lt;file-to-attach&gt;</code><br>
<code class="highlighter-rouge">fastscore attachment upload ELMo_nlp-py3 library/attachments/ELMo_nlp_xgboost.tar.gz</code></p>

<h3 id="5-streams"><a name="streams"></a>5. Streams</h3>
<p>Streams in FastScore define the integration to our data pipeline. 
Streams will read records from underlying transport, verify with the schema, and feed them to the model. 
A stream is defined via a JSON document that controls behavior and connection. 
For this example, we will be deploying and testing the model as REST.</p>

<p>In the next step, we will use the CLI to generate two arbitrary REST endpoints for testing the model. 
While the arbitrary REST endpoints are not realistic for production, they are an extremely handy approach for quick testing. 
We can also define the REST stream as a JSON file to be added and tracked in Model Manage:
<!-- HTML generated using hilite.me -->
<div style="background: #f8f8f8; overflow:auto;width:auto;border:solid gray;border-width:.1em .1em .1em .8em;padding:.2em .6em;">
    <pre style="margin: 0; line-height: 125%">{
  <span style="color: #008000; font-weight: bold">&quot;Transport&quot;</span>: <span style="color: #BA2121">&quot;REST&quot;</span>,
  <span style="color: #008000; font-weight: bold">&quot;Encoding&quot;</span>: <span style="color: #BA2121">&quot;json&quot;</span>
}
</pre></div>
</p>

<p>To add a stream, we use the following CLI command:</p>
<p><code class="highlighter-rouge">fastscore stream add &lt;stream-name&gt; &lt;file-name&gt;</code><br>
<code class="highlighter-rouge">fastscore stream add rest library/streams/rest.json</code></p>

<h2 id="deploy-as-rest"><a name="Deploy-as-REST"></a>Deploy as REST</h2>
<p>Now that we have the Model Deployment Package defined and added to FastScore, it’s time to deploy it in the Engine and test as REST. 
Using <code class="highlighter-rouge">rest:</code> for the streams in the run command will generate an endpoint 
for the input and output slots.</p>

<p>Generic commands for deploying a model:</p>
<div class="highlighter-rouge">
    <div class="highlight">
        <pre class="highlight">
<code>fastscore use &lt;engine-name&gt;
fastscore engine reset
fastscore run &lt;model-name&gt; rest: rest:
fastscore engine inspect</code>
</pre></div></div>

<p>For our example:</p>

<div class="highlighter-rouge">
    <div class="highlight">
        <pre class="highlight">
<code>fastscore use engine-1
fastscore engine reset
fastscore run ELMo_nlp-py3 rest: rest:
fastscore engine inspect</code>
</pre></div></div>

<p>Troubleshooting Tip: At this point, the model is loaded into the Engine, initialized, and awaiting data. 
The last <code class="highlighter-rouge">inspect</code> should return <code class="highlighter-rouge">RUNNING</code> 
to indicate the model is ready for data. If the <code class="highlighter-rouge">inspect</code> command returns an error, 
there was most likely an issue with the <a href="#model-dependencies">Model Dependencies</a>, 
the <a href="#attachments">Attachment</a> or how they were referenced in the 
<a href="#model-execution-script">Model Execution Script</a>. 
Check the logs of the Engine to investigate the error messages: 
<pre class="highlight"><code>docker logs &lt;container-id or container-name&gt;</code></pre></p>

<h2 id="test-model"><a name="Test-Model"></a>Test Model</h2>
<p>Finally, we’re going to send data to the model to test the Model Deployment Package entirely for prediction. 
To send data contained in <code class="highlighter-rouge">input_data.json</code> 
via the CLI, and retrieve predictions, we use the following commands:</p>

<div class="highlighter-rouge">
    <div class="highlight">
        <pre class="highlight">
<code>cat data/input_data.json | fastscore model input
fastscore model output -c</code>
</pre></div></div>

<p>This model takes some time to run. Once finished, we can see the output from our model as a list of probabilities, 
each corresponding to a prediction on an input record.</p>
<br>
</body>
</html>
