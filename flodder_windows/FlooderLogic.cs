namespace Flodder;

public class FlooderLogic
{
    public bool IsFlooding { get; private set; }
    public event Action<bool>? OnStateChanged;
    
    private CancellationTokenSource? cts;

    public void Start(string text, int delayMs)
    {
        if (IsFlooding) return;
        
        IsFlooding = true;
        OnStateChanged?.Invoke(true);
        cts = new CancellationTokenSource();

        Task.Run(async () =>
        {
            try
            {
                while (!cts.Token.IsCancellationRequested)
                {
                    // Sequential: Type -> Enter -> Delay
                    
                    // Windows SendKeys is synchronous and waits for processing usually
                    // Use wait to simulate typing delay if needed, but SendKeys sends whole string
                    // To act more human-like or handle heavy apps, we might split it or just send it.
                    // For now, SendKeys.SendWait(text) is robust.
                    
                    SendKeys.SendWait(text);
                    await Task.Delay(50, cts.Token); // Small pause before Enter
                    
                    SendKeys.SendWait("{ENTER}");
                    
                    await Task.Delay(delayMs, cts.Token);
                }
            }
            catch (OperationCanceledException)
            {
                // Stopped intentionally
            }
            finally
            {
                IsFlooding = false;
                OnStateChanged?.Invoke(false);
            }
        }, cts.Token);
    }

    public void Stop()
    {
        cts?.Cancel();
    }
}
