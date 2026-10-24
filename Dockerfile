FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Install both the Verilog compiler and runtime; the app needs both commands.
RUN apt-get update \
    && apt-get install -y --no-install-recommends iverilog \
    && command -v iverilog \
    && command -v vvp \
    && printf 'module iv_smoke; initial begin $display("IVL_OK"); $finish; end endmodule\n' > /tmp/iv_smoke.v \
    && iverilog -o /tmp/iv_smoke.out /tmp/iv_smoke.v \
    && vvp /tmp/iv_smoke.out | grep -q IVL_OK \
    && rm -f /tmp/iv_smoke.v /tmp/iv_smoke.out \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py README.md ./
RUN python -m py_compile app.py \
    && command -v iverilog \
    && command -v vvp

EXPOSE 7860
CMD ["python", "app.py"]
