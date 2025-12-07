namespace TestProgramApp
{
    partial class Form1
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
            button1 = new Button();
            button2 = new Button();
            button3 = new Button();
            button4 = new Button();
            button5 = new Button();
            button6 = new Button();
            textBox1 = new TextBox();
            textBox2 = new TextBox();
            panel1 = new Panel();
            radioButton4 = new RadioButton();
            radioButton3 = new RadioButton();
            radioButton2 = new RadioButton();
            radioButton1 = new RadioButton();
            TeamA = new NumericUpDown();
            teamB = new NumericUpDown();
            button7 = new Button();
            label1 = new Label();
            panel1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)TeamA).BeginInit();
            ((System.ComponentModel.ISupportInitialize)teamB).BeginInit();
            SuspendLayout();
            // 
            // button1
            // 
            button1.BackColor = SystemColors.ControlLightLight;
            button1.Location = new Point(161, 367);
            button1.Name = "button1";
            button1.Size = new Size(149, 56);
            button1.TabIndex = 0;
            button1.Text = "Challenge";
            button1.UseVisualStyleBackColor = false;
            button1.Click += button1_Click;
            // 
            // button2
            // 
            button2.Location = new Point(1176, 367);
            button2.Name = "button2";
            button2.Size = new Size(149, 56);
            button2.TabIndex = 1;
            button2.Text = "Challenge";
            button2.UseVisualStyleBackColor = true;
            button2.Click += button2_Click;
            // 
            // button3
            // 
            button3.Location = new Point(161, 468);
            button3.Name = "button3";
            button3.Size = new Size(149, 56);
            button3.TabIndex = 2;
            button3.Text = "Time Out";
            button3.UseVisualStyleBackColor = true;
            button3.Click += button3_Click;
            // 
            // button4
            // 
            button4.Location = new Point(1176, 468);
            button4.Name = "button4";
            button4.Size = new Size(149, 56);
            button4.TabIndex = 3;
            button4.Text = "Time Out";
            button4.UseVisualStyleBackColor = true;
            button4.Click += button4_Click;
            // 
            // button5
            // 
            button5.Location = new Point(161, 571);
            button5.Name = "button5";
            button5.Size = new Size(149, 56);
            button5.TabIndex = 4;
            button5.Text = "Substitute";
            button5.UseVisualStyleBackColor = true;
            button5.Click += button5_Click;
            // 
            // button6
            // 
            button6.Location = new Point(1176, 571);
            button6.Name = "button6";
            button6.Size = new Size(149, 56);
            button6.TabIndex = 5;
            button6.Text = "Substitute";
            button6.UseVisualStyleBackColor = true;
            button6.Click += button6_Click;
            // 
            // textBox1
            // 
            textBox1.Location = new Point(161, 35);
            textBox1.Name = "textBox1";
            textBox1.Size = new Size(149, 31);
            textBox1.TabIndex = 6;
            textBox1.Text = "Team A";
            textBox1.TextAlign = HorizontalAlignment.Center;
            textBox1.TextChanged += textBox1_TextChanged;
            // 
            // textBox2
            // 
            textBox2.Location = new Point(1176, 35);
            textBox2.Name = "textBox2";
            textBox2.Size = new Size(149, 31);
            textBox2.TabIndex = 7;
            textBox2.Text = "Team B";
            textBox2.TextAlign = HorizontalAlignment.Center;
            // 
            // panel1
            // 
            panel1.Controls.Add(radioButton4);
            panel1.Controls.Add(radioButton3);
            panel1.Controls.Add(radioButton2);
            panel1.Controls.Add(radioButton1);
            panel1.Location = new Point(536, 571);
            panel1.Name = "panel1";
            panel1.Size = new Size(328, 74);
            panel1.TabIndex = 8;
            // 
            // radioButton4
            // 
            radioButton4.Appearance = Appearance.Button;
            radioButton4.AutoSize = true;
            radioButton4.Location = new Point(261, 21);
            radioButton4.Name = "radioButton4";
            radioButton4.Size = new Size(46, 35);
            radioButton4.TabIndex = 3;
            radioButton4.TabStop = true;
            radioButton4.Text = "Q4";
            radioButton4.UseVisualStyleBackColor = true;
            radioButton4.CheckedChanged += radioButton4_CheckedChanged;
            // 
            // radioButton3
            // 
            radioButton3.Appearance = Appearance.Button;
            radioButton3.AutoSize = true;
            radioButton3.Location = new Point(189, 21);
            radioButton3.Name = "radioButton3";
            radioButton3.Size = new Size(46, 35);
            radioButton3.TabIndex = 2;
            radioButton3.TabStop = true;
            radioButton3.Text = "Q3";
            radioButton3.UseVisualStyleBackColor = true;
            radioButton3.CheckedChanged += radioButton3_CheckedChanged;
            // 
            // radioButton2
            // 
            radioButton2.Appearance = Appearance.Button;
            radioButton2.AutoSize = true;
            radioButton2.Location = new Point(103, 21);
            radioButton2.Name = "radioButton2";
            radioButton2.Size = new Size(46, 35);
            radioButton2.TabIndex = 1;
            radioButton2.TabStop = true;
            radioButton2.Text = "Q2";
            radioButton2.UseVisualStyleBackColor = true;
            radioButton2.CheckedChanged += radioButton2_CheckedChanged;
            // 
            // radioButton1
            // 
            radioButton1.Appearance = Appearance.Button;
            radioButton1.AutoSize = true;
            radioButton1.Location = new Point(26, 21);
            radioButton1.Name = "radioButton1";
            radioButton1.Size = new Size(46, 35);
            radioButton1.TabIndex = 0;
            radioButton1.TabStop = true;
            radioButton1.Text = "Q1";
            radioButton1.UseVisualStyleBackColor = true;
            radioButton1.CheckedChanged += radioButton1_CheckedChanged;
            // 
            // TeamA
            // 
            TeamA.Location = new Point(562, 200);
            TeamA.Maximum = new decimal(new int[] { 99, 0, 0, 0 });
            TeamA.Name = "TeamA";
            TeamA.ReadOnly = true;
            TeamA.Size = new Size(60, 31);
            TeamA.TabIndex = 9;
            // 
            // teamB
            // 
            teamB.Location = new Point(783, 200);
            teamB.Maximum = new decimal(new int[] { 99, 0, 0, 0 });
            teamB.Name = "teamB";
            teamB.ReadOnly = true;
            teamB.Size = new Size(60, 31);
            teamB.TabIndex = 10;
            // 
            // button7
            // 
            button7.Location = new Point(562, 449);
            button7.Name = "button7";
            button7.Size = new Size(281, 75);
            button7.TabIndex = 11;
            button7.Text = "GAME OVER";
            button7.UseVisualStyleBackColor = true;
            button7.Click += button7_Click;
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.BackColor = SystemColors.ButtonFace;
            label1.Location = new Point(670, 206);
            label1.Name = "label1";
            label1.Size = new Size(67, 25);
            label1.TabIndex = 12;
            label1.Text = "SCORE";
            // 
            // Form1
            // 
            AutoScaleDimensions = new SizeF(10F, 25F);
            AutoScaleMode = AutoScaleMode.Font;
            BackColor = SystemColors.GrayText;
            BackgroundImage = (Image)resources.GetObject("$this.BackgroundImage");
            BackgroundImageLayout = ImageLayout.Stretch;
            ClientSize = new Size(1406, 710);
            Controls.Add(label1);
            Controls.Add(button7);
            Controls.Add(teamB);
            Controls.Add(TeamA);
            Controls.Add(panel1);
            Controls.Add(textBox2);
            Controls.Add(textBox1);
            Controls.Add(button6);
            Controls.Add(button5);
            Controls.Add(button4);
            Controls.Add(button3);
            Controls.Add(button2);
            Controls.Add(button1);
            MinimizeBox = false;
            Name = "Form1";
            Text = "Form1";
            panel1.ResumeLayout(false);
            panel1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)TeamA).EndInit();
            ((System.ComponentModel.ISupportInitialize)teamB).EndInit();
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private Button button1;
        private Button button2;
        private Button button3;
        private Button button4;
        private Button button5;
        private Button button6;
        private TextBox textBox1;
        private TextBox textBox2;
        private Panel panel1;
        private RadioButton radioButton1;
        private RadioButton radioButton4;
        private RadioButton radioButton3;
        private RadioButton radioButton2;
        private NumericUpDown TeamA;
        private NumericUpDown teamB;
        private Button button7;
        private Label label1;
    }
}
