using System.Runtime.InteropServices;
using System.Security.Cryptography;

namespace Flodder;

public partial class Form1 : Form
{
    private NotifyIcon trayIcon;
    private FlooderLogic flooder;
    private TextBox txtMessage;
    private TextBox txtDelay;
    private Button btnStart;
    private Label lblMessage;
    private Label lblDelay;
    private Panel pnlStatus;

    public Form1()
    {
        InitializeComponent();
        flooder = new FlooderLogic();
        flooder.OnStateChanged += Flooder_OnStateChanged;

        // Register Global Hotkey (Cmd+Shift+Alt+F -> Ctrl+Shift+Alt+F on Windows)
        // ID 1, MOD_ALT | MOD_CONTROL | MOD_SHIFT = 1 | 2 | 4 = 7, Keys.F
        NativeMethods.RegisterHotKey(this.Handle, 1, 7, (int)Keys.F);
    }

    private void InitializeComponent()
    {
        this.Size = new Size(420, 90);
        this.FormBorderStyle = FormBorderStyle.FixedSingle;
        this.MaximizeBox = false;
        this.Text = "Flodder";
        this.BackColor = Color.FromArgb(30, 30, 30);
        this.ForeColor = Color.White;

        // Message
        lblMessage = new Label { Text = "MESSAGGIO", Location = new Point(10, 10), Size = new Size(80, 15), ForeColor = Color.Gray, Font = new Font("Segoe UI", 7, FontStyle.Bold) };
        txtMessage = new TextBox { Text = "Hello!", Location = new Point(10, 28), Size = new Size(220, 23), BackColor = Color.FromArgb(50, 50, 50), ForeColor = Color.White, BorderStyle = BorderStyle.FixedSingle };

        // Delay
        lblDelay = new Label { Text = "DELAY", Location = new Point(240, 10), Size = new Size(50, 15), ForeColor = Color.Gray, Font = new Font("Segoe UI", 7, FontStyle.Bold) };
        txtDelay = new TextBox { Text = "1000", Location = new Point(240, 28), Size = new Size(50, 23), BackColor = Color.FromArgb(50, 50, 50), ForeColor = Color.White, BorderStyle = BorderStyle.FixedSingle };

        // Start Button
        btnStart = new Button { Text = "START", Location = new Point(300, 26), Size = new Size(60, 27), BackColor = Color.DodgerBlue, ForeColor = Color.White, FlatStyle = FlatStyle.Flat };
        btnStart.FlatAppearance.BorderSize = 0;
        btnStart.Click += (s, e) => ToggleFlooding();

        // Status Indicator
        pnlStatus = new Panel { Location = new Point(370, 32), Size = new Size(12, 12), BackColor = Color.Green };
        using (var path = new System.Drawing.Drawing2D.GraphicsPath())
        {
            path.AddEllipse(0, 0, 12, 12);
            pnlStatus.Region = new Region(path);
        }

        this.Controls.Add(lblMessage);
        this.Controls.Add(txtMessage);
        this.Controls.Add(lblDelay);
        this.Controls.Add(txtDelay);
        this.Controls.Add(btnStart);
        this.Controls.Add(pnlStatus);
    }

    protected override void WndProc(ref Message m)
    {
        if (m.Msg == 0x0312 && m.WParam.ToInt32() == 1) // WM_HOTKEY
        {
            ToggleFlooding();
        }
        base.WndProc(ref m);
    }

    private void ToggleFlooding()
    {
        if (flooder.IsFlooding)
        {
            flooder.Stop();
        }
        else
        {
            if (int.TryParse(txtDelay.Text, out int delay))
            {
                flooder.Start(txtMessage.Text, delay);
            }
        }
    }

    private void Flooder_OnStateChanged(bool isFlooding)
    {
        if (InvokeRequired)
        {
            Invoke(new Action<bool>(Flooder_OnStateChanged), isFlooding);
            return;
        }

        btnStart.Text = isFlooding ? "STOP" : "START";
        btnStart.BackColor = isFlooding ? Color.Crimson : Color.DodgerBlue;
        pnlStatus.BackColor = isFlooding ? Color.Crimson : Color.Green;
    }

    protected override void OnFormClosing(FormClosingEventArgs e)
    {
        NativeMethods.UnregisterHotKey(this.Handle, 1);
        base.OnFormClosing(e);
    }
}
